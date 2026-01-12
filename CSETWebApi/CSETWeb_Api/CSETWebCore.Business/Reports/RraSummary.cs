//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Reports
{
    public class RRASummary
    {
        private readonly CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public RRASummary(CSETContext context)
        {
            this._context = context;
        }

        public async Task<List<usp_getRRASummaryOverall>> GetSummaryOverallAsync(int assessmentId)
        {
            var validAnswers = new[] { "Y", "N", "U" };

            // Check for submodel filter (replicates func_AM logic)
            var submodel = await _context.DETAILS_DEMOGRAPHICS
                .AsNoTracking()
                .Where(d => d.Assessment_Id == assessmentId && d.DataItemName == "MATURITY-SUBMODEL")
                .Select(d => d.StringValue)
                .FirstOrDefaultAsync();

            // Build base query for maturity answers
            var baseQuery = _context.Answer_Maturity.AsNoTracking()
                .Where(am => am.Assessment_Id == assessmentId && am.Is_Maturity == true);

            // Apply submodel filter if present
            if (submodel != null)
            {
                var submodelQuestionIds = _context.MATURITY_SUB_MODEL_QUESTIONS
                    .AsNoTracking()
                    .Where(sq => sq.Sub_Model_Name == submodel)
                    .Select(sq => sq.Mat_Question_Id);

                baseQuery = baseQuery.Where(am => submodelQuestionIds.Contains(am.Question_Or_Requirement_Id));
            }

            // Get answer counts (join with MATURITY_LEVELS to match SP behavior)
            var answerCounts = await (
                from am in baseQuery
                join ml in _context.MATURITY_LEVELS.AsNoTracking()
                    on am.Maturity_Level_Id equals ml.Maturity_Level_Id
                group am by am.Answer_Text into g
                select new { Answer_Text = g.Key, qc = g.Count() }
            ).ToListAsync();

            int total = answerCounts.Sum(x => x.qc);

            // Get answer lookups with ordering (only Y, N, U)
            var answerLookups = await (
                from al in _context.ANSWER_LOOKUP.AsNoTracking()
                join ao in _context.ANSWER_ORDER.AsNoTracking() on al.Answer_Text equals ao.Answer_Text
                where validAnswers.Contains(al.Answer_Text)
                orderby ao.answer_order1
                select new { al.Answer_Full_Name, al.Answer_Text }
            ).ToListAsync();

            return answerLookups
                .Select(x =>
                {
                    var count = answerCounts.FirstOrDefault(c => c.Answer_Text == x.Answer_Text);
                    int qc = count?.qc ?? 0;
                    return new usp_getRRASummaryOverall
                    {
                        Assessment_Id = assessmentId,
                        Answer_Full_Name = x.Answer_Full_Name,
                        Answer_Text = x.Answer_Text,
                        qc = qc,
                        Total = total,
                        Percent = total > 0 ? Math.Round((double)qc / total * 100, 2) : 0
                    };
                })
                .ToList();
        }

        public async Task<List<usp_getRRASummary>> GetRRASummaryAsync(int assessmentId)
        {
            const int RRA_MODEL_ID = 5;
            var validAnswers = new[] { "Y", "N", "U" };

            // Check for submodel filter (replicates func_AM logic)
            var submodel = await _context.DETAILS_DEMOGRAPHICS
                .AsNoTracking()
                .Where(d => d.Assessment_Id == assessmentId && d.DataItemName == "MATURITY-SUBMODEL")
                .Select(d => d.StringValue)
                .FirstOrDefaultAsync();

            // Get RRA maturity levels (Maturity_Model_Id = 5), ordered by Level
            var maturityLevels = await _context.MATURITY_LEVELS
                .AsNoTracking()
                .Where(ml => ml.Maturity_Model_Id == RRA_MODEL_ID)
                .OrderBy(ml => ml.Level)
                .Select(ml => new { ml.Maturity_Level_Id, ml.Level, ml.Level_Name })
                .ToListAsync();

            // Get answer lookups with ordering (only Y, N, U)
            var answerLookups = await (
                from al in _context.ANSWER_LOOKUP.AsNoTracking()
                join ao in _context.ANSWER_ORDER.AsNoTracking() on al.Answer_Text equals ao.Answer_Text
                where validAnswers.Contains(al.Answer_Text)
                orderby ao.answer_order1
                select new { al.Answer_Full_Name, al.Answer_Text, ao.answer_order1 }
            ).ToListAsync();

            // Build base query for maturity answers
            var baseQuery = _context.Answer_Maturity.AsNoTracking()
                .Where(am => am.Assessment_Id == assessmentId && am.Is_Maturity == true);

            // Apply submodel filter if present
            if (submodel != null)
            {
                var submodelQuestionIds = _context.MATURITY_SUB_MODEL_QUESTIONS
                    .AsNoTracking()
                    .Where(sq => sq.Sub_Model_Name == submodel)
                    .Select(sq => sq.Mat_Question_Id);

                baseQuery = baseQuery.Where(am => submodelQuestionIds.Contains(am.Question_Or_Requirement_Id));
            }

            // Get answer counts grouped by Level_Name and Answer_Text
            var answerCounts = await (
                from am in baseQuery
                join ml in _context.MATURITY_LEVELS.AsNoTracking()
                    on am.Maturity_Level_Id equals ml.Maturity_Level_Id
                where ml.Maturity_Model_Id == RRA_MODEL_ID
                group am by new { ml.Level_Name, am.Answer_Text } into g
                select new
                {
                    g.Key.Level_Name,
                    g.Key.Answer_Text,
                    Count = g.Count()
                }
            ).ToListAsync();

            // Calculate totals per level (replicates OVER(PARTITION BY Level_Name))
            var levelTotals = answerCounts
                .GroupBy(x => x.Level_Name)
                .ToDictionary(g => g.Key, g => g.Sum(x => x.Count));

            // Build result: cross-join levels with answers, left-join with counts
            var results = new List<usp_getRRASummary>();
            foreach (var level in maturityLevels.OrderBy(l => l.Level))
            {
                int total = levelTotals.GetValueOrDefault(level.Level_Name, 0);
                foreach (var answer in answerLookups.OrderBy(a => a.answer_order1))
                {
                    int qc = answerCounts
                        .FirstOrDefault(c => c.Level_Name == level.Level_Name && c.Answer_Text == answer.Answer_Text)?.Count ?? 0;

                    results.Add(new usp_getRRASummary
                    {
                        Assessment_Id = assessmentId,
                        Answer_Full_Name = answer.Answer_Full_Name,
                        Level_Name = level.Level_Name,
                        Answer_Text = answer.Answer_Text,
                        qc = qc,
                        Total = total,
                        Percent = total > 0 ? Math.Round((double)qc / total * 100, 2) : 0
                    });
                }
            }

            return results;
        }

        public async Task<List<usp_getRRASummaryByGoal>> GetRRASummaryByGoalAsync(int assessmentId)
        {
            const int RRA_MODEL_ID = 5;
            const int GOAL_LEVEL = 2;
            var validAnswers = new[] { "Y", "N", "U" };

            // Check for submodel filter (replicates func_AM/func_MQ logic)
            var submodel = await _context.DETAILS_DEMOGRAPHICS
                .AsNoTracking()
                .Where(d => d.Assessment_Id == assessmentId && d.DataItemName == "MATURITY-SUBMODEL")
                .Select(d => d.StringValue)
                .FirstOrDefaultAsync();

            // Get all goals for RRA model at Group_Level = 2
            var goals = await _context.MATURITY_GROUPINGS
                .AsNoTracking()
                .Where(g => g.Maturity_Model_Id == RRA_MODEL_ID && g.Group_Level == GOAL_LEVEL)
                .OrderBy(g => g.Sequence)
                .Select(g => new { g.Title, g.Grouping_Id, g.Sequence })
                .ToListAsync();

            // Get answer lookups with ordering (only Y, N, U)
            var answerLookups = await (
                from al in _context.ANSWER_LOOKUP.AsNoTracking()
                join ao in _context.ANSWER_ORDER.AsNoTracking() on al.Answer_Text equals ao.Answer_Text
                where validAnswers.Contains(al.Answer_Text)
                orderby ao.answer_order1
                select new { al.Answer_Full_Name, al.Answer_Text, ao.answer_order1 }
            ).ToListAsync();

            // Build base query for answered questions
            var baseQuery =
                from am in _context.Answer_Maturity.AsNoTracking()
                join mq in _context.MATURITY_QUESTIONS.AsNoTracking()
                    on am.Question_Or_Requirement_Id equals mq.Mat_Question_Id
                join mg in _context.MATURITY_GROUPINGS.AsNoTracking()
                    on new { Grouping_Id = mq.Grouping_Id, Maturity_Model_Id = (int?)mq.Maturity_Model_Id }
                    equals new { Grouping_Id = (int?)mg.Grouping_Id, Maturity_Model_Id = (int?)mg.Maturity_Model_Id }
                where am.Assessment_Id == assessmentId
                    && am.Is_Maturity == true
                    && mq.Maturity_Model_Id == RRA_MODEL_ID
                    && mg.Group_Level == GOAL_LEVEL
                    && validAnswers.Contains(am.Answer_Text)
                select new { am, mq, mg };

            // Apply submodel filter if present
            if (submodel != null)
            {
                var submodelQuestionIds = _context.MATURITY_SUB_MODEL_QUESTIONS
                    .AsNoTracking()
                    .Where(sq => sq.Sub_Model_Name == submodel)
                    .Select(sq => sq.Mat_Question_Id);

                baseQuery = baseQuery.Where(x => submodelQuestionIds.Contains(x.mq.Mat_Question_Id));
            }

            // Get answer counts grouped by (Title, Answer_Text)
            var answerCounts = await baseQuery
                .GroupBy(x => new { x.mg.Title, x.am.Answer_Text })
                .Select(g => new { g.Key.Title, g.Key.Answer_Text, Count = g.Count() })
                .ToListAsync();

            // Calculate totals per goal
            var goalTotals = answerCounts
                .GroupBy(x => x.Title)
                .ToDictionary(g => g.Key, g => g.Sum(x => x.Count));

            // Build result: cross-join goals with answer lookups, left-join with counts
            var results = new List<usp_getRRASummaryByGoal>();
            foreach (var goal in goals.OrderBy(g => g.Sequence))
            {
                int total = goalTotals.GetValueOrDefault(goal.Title, 0);
                foreach (var answer in answerLookups.OrderBy(a => a.answer_order1))
                {
                    int qc = answerCounts
                        .FirstOrDefault(c => c.Title == goal.Title && c.Answer_Text == answer.Answer_Text)?.Count ?? 0;

                    results.Add(new usp_getRRASummaryByGoal
                    {
                        Assessment_Id = assessmentId,
                        Answer_Full_Name = answer.Answer_Full_Name,
                        Title = goal.Title,
                        Grouping_Id = goal.Grouping_Id,
                        Answer_Text = answer.Answer_Text,
                        qc = qc,
                        Total = total,
                        Percent = total > 0 ? Math.Round((double)qc / total * 100, 2) : 0
                    });
                }
            }

            return results;
        }

        public async Task<List<usp_getRRASummaryByGoalOverall>> GetRRASummaryByGoalOverallAsync(int assessmentId)
        {
            const int RRA_MODEL_ID = 5;
            const int GOAL_LEVEL = 2;

            // Check for submodel filter (replicates func_AM/func_MQ logic)
            var submodel = await _context.DETAILS_DEMOGRAPHICS
                .AsNoTracking()
                .Where(d => d.Assessment_Id == assessmentId && d.DataItemName == "MATURITY-SUBMODEL")
                .Select(d => d.StringValue)
                .FirstOrDefaultAsync();

            // Get all goals for RRA model at Group_Level = 2, ordered by Sequence
            var goals = await _context.MATURITY_GROUPINGS
                .AsNoTracking()
                .Where(g => g.Maturity_Model_Id == RRA_MODEL_ID && g.Group_Level == GOAL_LEVEL)
                .OrderBy(g => g.Sequence)
                .Select(g => new { g.Title, g.Grouping_Id })
                .ToListAsync();

            // Build base query for answered questions
            var baseQuery =
                from am in _context.Answer_Maturity.AsNoTracking()
                join mq in _context.MATURITY_QUESTIONS.AsNoTracking()
                    on am.Question_Or_Requirement_Id equals mq.Mat_Question_Id
                join mg in _context.MATURITY_GROUPINGS.AsNoTracking()
                    on new { Grouping_Id = mq.Grouping_Id, Maturity_Model_Id = (int?)mq.Maturity_Model_Id }
                    equals new { Grouping_Id = (int?)mg.Grouping_Id, Maturity_Model_Id = (int?)mg.Maturity_Model_Id }
                where am.Assessment_Id == assessmentId
                    && am.Is_Maturity == true
                    && mq.Maturity_Model_Id == RRA_MODEL_ID
                    && mg.Group_Level == GOAL_LEVEL
                select new { am, mq, mg };

            // Apply submodel filter if present
            if (submodel != null)
            {
                var submodelQuestionIds = _context.MATURITY_SUB_MODEL_QUESTIONS
                    .AsNoTracking()
                    .Where(sq => sq.Sub_Model_Name == submodel)
                    .Select(sq => sq.Mat_Question_Id);

                baseQuery = baseQuery.Where(x => submodelQuestionIds.Contains(x.mq.Mat_Question_Id));
            }

            // Get answered question counts per goal
            var answerCounts = await baseQuery
                .GroupBy(x => x.mg.Title)
                .Select(g => new { Title = g.Key, Count = g.Count() })
                .ToListAsync();

            int total = answerCounts.Sum(x => x.Count);

            return goals.Select(g =>
            {
                int qc = answerCounts.FirstOrDefault(a => a.Title == g.Title)?.Count ?? 0;
                return new usp_getRRASummaryByGoalOverall
                {
                    Assessment_Id = assessmentId,
                    Title = g.Title,
                    qc = qc,
                    Total = total,
                    Percent = total > 0 ? Math.Round((double)qc / total * 100, 2) : 0
                };
            }).ToList();
        }
    }
}