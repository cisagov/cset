//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
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
    public class VADRReports
    {

        private readonly CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public VADRReports(CSETContext context)
        {
            this._context = context;
        }

        public async Task<List<usp_getVADRSummaryOverall>> GetSummaryOverallAsync(int assessmentId)
        {
            // Get answer counts for parent questions only (exclude child freeform text questions)
            // Using AsNoTracking() for read-only query performance
            var answerCounts = await (
                from am in _context.Answer_Maturity.AsNoTracking()
                join mq in _context.MATURITY_QUESTIONS.AsNoTracking()
                    on am.Question_Or_Requirement_Id equals mq.Mat_Question_Id
                where am.Assessment_Id == assessmentId
                   && mq.Parent_Question_Id == null
                group am by am.Answer_Text into g
                select new { Answer_Text = g.Key, qc = g.Count() }
            ).ToListAsync();

            int total = answerCounts.Sum(x => x.qc);

            // Build results for all answer types (Y, N, U, A) ordered correctly
            var validAnswers = new[] { "Y", "N", "U", "A" };

            // Project only needed columns from lookup tables
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
                    return new usp_getVADRSummaryOverall
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

        /// <summary>
        /// Gets the VADR summary data by maturity level.
        /// This replaces the usp_getVADRSummary stored procedure.
        /// </summary>
        public async Task<List<usp_getVADRSummary>> GetVADRSummaryAsync(int assessmentId)
        {
            const int VADR_MODEL_ID = 7;
            var validAnswers = new[] { "Y", "N", "A", "U" };

            // Get maturity levels for VADR model
            var levels = await _context.MATURITY_LEVELS
                .AsNoTracking()
                .Where(l => l.Maturity_Model_Id == VADR_MODEL_ID)
                .OrderBy(l => l.Level)
                .Select(l => new { l.Maturity_Level_Id, l.Level_Name, l.Level })
                .ToListAsync();

            // Get answer lookups with ordering
            var answerLookups = await (
                from al in _context.ANSWER_LOOKUP.AsNoTracking()
                join ao in _context.ANSWER_ORDER.AsNoTracking() on al.Answer_Text equals ao.Answer_Text
                where validAnswers.Contains(al.Answer_Text)
                select new { al.Answer_Full_Name, al.Answer_Text, ao.answer_order1 }
            ).ToListAsync();

            // Get answer counts per level (parent questions only)
            var answerCounts = await (
                from am in _context.Answer_Maturity.AsNoTracking()
                join mq in _context.MATURITY_QUESTIONS.AsNoTracking()
                    on am.Question_Or_Requirement_Id equals mq.Mat_Question_Id
                join ml in _context.MATURITY_LEVELS.AsNoTracking()
                    on am.Maturity_Level_Id equals ml.Maturity_Level_Id
                where am.Assessment_Id == assessmentId
                    && am.Is_Maturity == true
                    && mq.Parent_Question_Id == null
                group am by new { ml.Level_Name, am.Answer_Text, ml.Maturity_Level_Id } into g
                select new { g.Key.Level_Name, g.Key.Answer_Text, g.Key.Maturity_Level_Id, qc = g.Count() }
            ).ToListAsync();

            // Calculate totals per level
            var levelTotals = answerCounts
                .GroupBy(a => a.Level_Name)
                .ToDictionary(g => g.Key, g => g.Sum(x => x.qc));

            // Build result by cross-joining levels with answer types
            var results = (
                from level in levels
                from answer in answerLookups
                let count = answerCounts.FirstOrDefault(c => c.Level_Name == level.Level_Name && c.Answer_Text == answer.Answer_Text)
                let qc = count?.qc ?? 0
                let total = levelTotals.GetValueOrDefault(level.Level_Name, 0)
                orderby level.Level, answer.answer_order1
                select new usp_getVADRSummary
                {
                    Assessment_Id = assessmentId,
                    Answer_Full_Name = answer.Answer_Full_Name,
                    Level_Name = level.Level_Name,
                    Answer_Text = answer.Answer_Text,
                    qc = qc,
                    Total = total,
                    Percent = total > 0 ? Math.Round((double)qc / total * 100, 2) : 0
                }
            ).ToList();

            return results;
        }

        public async Task<List<usp_getVADRSummaryByGoal>> GetVADRSummaryByGoalAsync(int assessmentId)
        {
            const int VADR_MODEL_ID = 7;
            const int GOAL_LEVEL = 2;
            var validAnswers = new[] { "Y", "N", "A", "U" };

            // Get all goals for VADR model at Group_Level = 2, ordered by Sequence
            var goals = await _context.MATURITY_GROUPINGS
                .AsNoTracking()
                .Where(g => g.Maturity_Model_Id == VADR_MODEL_ID && g.Group_Level == GOAL_LEVEL)
                .OrderBy(g => g.Sequence)
                .Select(g => new { g.Title, g.Sequence, g.Grouping_Id })
                .ToListAsync();

            // Get answer lookups with ordering
            var answerLookups = await (
                from al in _context.ANSWER_LOOKUP.AsNoTracking()
                join ao in _context.ANSWER_ORDER.AsNoTracking() on al.Answer_Text equals ao.Answer_Text
                where validAnswers.Contains(al.Answer_Text)
                select new { al.Answer_Full_Name, al.Answer_Text, ao.answer_order1 }
            ).ToListAsync();

            // Get answer counts per goal and answer type (parent questions only)
            var answerCounts = await (
                from am in _context.Answer_Maturity.AsNoTracking()
                join mq in _context.MATURITY_QUESTIONS.AsNoTracking()
                    on am.Question_Or_Requirement_Id equals mq.Mat_Question_Id
                join mg in _context.MATURITY_GROUPINGS.AsNoTracking()
                    on new { Grouping_Id = mq.Grouping_Id, Maturity_Model_Id = (int?)mq.Maturity_Model_Id }
                    equals new { Grouping_Id = (int?)mg.Grouping_Id, Maturity_Model_Id = (int?)mg.Maturity_Model_Id }
                where am.Assessment_Id == assessmentId
                    && am.Is_Maturity == true
                    && mq.Parent_Question_Id == null
                    && mq.Maturity_Model_Id == VADR_MODEL_ID
                    && mg.Group_Level == GOAL_LEVEL
                group am by new { mg.Title, mg.Sequence, am.Answer_Text } into g
                select new { g.Key.Title, g.Key.Sequence, g.Key.Answer_Text, qc = g.Count() }
            ).ToListAsync();

            // Calculate totals per goal
            var goalTotals = answerCounts
                .GroupBy(a => a.Title)
                .ToDictionary(g => g.Key, g => g.Sum(x => x.qc));

            // Build result by cross-joining goals with answer types
            var results = (
                from goal in goals
                from answer in answerLookups
                let count = answerCounts.FirstOrDefault(c => c.Title == goal.Title && c.Answer_Text == answer.Answer_Text)
                let qc = count?.qc ?? 0
                let total = goalTotals.GetValueOrDefault(goal.Title, 0)
                orderby goal.Sequence, answer.answer_order1
                select new usp_getVADRSummaryByGoal
                {
                    Assessment_Id = assessmentId,
                    Answer_Full_Name = answer.Answer_Full_Name,
                    Title = goal.Title,
                    Sequence = goal.Sequence,
                    Answer_Text = answer.Answer_Text,
                    qc = qc,
                    Total = total,
                    Percent = total > 0 ? Math.Round((double)qc / total * 100, 2) : 0
                }
            ).ToList();

            return results;
        }

        public async Task<List<usp_getVADRSummaryByGoalOverall>> GetVADRSummaryByGoalOverallAsync(int assessmentId)
        {
            const int VADR_MODEL_ID = 7;
            const int GOAL_LEVEL = 2;

            // Get all goals for VADR model at Group_Level = 2, ordered by Sequence
            var goals = await _context.MATURITY_GROUPINGS
                .AsNoTracking()
                .Where(g => g.Maturity_Model_Id == VADR_MODEL_ID && g.Group_Level == GOAL_LEVEL)
                .OrderBy(g => g.Sequence)
                .Select(g => new { g.Title, g.Grouping_Id })
                .ToListAsync();

            // Get answered question counts per goal (parent questions only)
            var answerCounts = await (
                from am in _context.Answer_Maturity.AsNoTracking()
                join mq in _context.MATURITY_QUESTIONS.AsNoTracking()
                    on am.Question_Or_Requirement_Id equals mq.Mat_Question_Id
                join mg in _context.MATURITY_GROUPINGS.AsNoTracking()
                    on new { Grouping_Id = mq.Grouping_Id, Maturity_Model_Id = (int?)mq.Maturity_Model_Id }
                    equals new { Grouping_Id = (int?)mg.Grouping_Id, Maturity_Model_Id = (int?)mg.Maturity_Model_Id }
                where am.Assessment_Id == assessmentId
                    && mq.Parent_Question_Id == null
                    && mq.Maturity_Model_Id == VADR_MODEL_ID
                    && mg.Group_Level == GOAL_LEVEL
                group am by mg.Title into g
                select new { Title = g.Key, Count = g.Count() }
            ).ToListAsync();

            int total = answerCounts.Sum(x => x.Count);

            return goals.Select(g =>
            {
                int qc = answerCounts.FirstOrDefault(a => a.Title == g.Title)?.Count ?? 0;
                return new usp_getVADRSummaryByGoalOverall
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