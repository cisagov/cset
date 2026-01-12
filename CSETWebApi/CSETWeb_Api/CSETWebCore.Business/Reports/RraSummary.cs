//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Snickler.EFCore;
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

        public List<usp_getRRASummary> GetRRASummary(int assessmentId)
        {
            List<usp_getRRASummary> results = null;

            _context.LoadStoredProc("[usp_getRRASummary]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<usp_getRRASummary>().ToList();
            });
            return results;

        }

        public List<usp_getRRASummaryByGoal> GetRRASummaryByGoal(int assessmentId)
        {
            List<usp_getRRASummaryByGoal> results = null;

            _context.LoadStoredProc("[usp_getRRASummaryByGoal]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<usp_getRRASummaryByGoal>().ToList();
            });
            return results;

        }

        public List<usp_getRRASummaryByGoalOverall> GetRRASummaryByGoalOverall(int assessmentId)
        {
            List<usp_getRRASummaryByGoalOverall> results = null;

            _context.LoadStoredProc("[usp_getRRASummaryByGoalOverall]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<usp_getRRASummaryByGoalOverall>().ToList();
            });
            return results;
        }
    }
}