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

        public List<usp_getVADRSummary> GetVADRSummary(int assessmentId)
        {
            List<usp_getVADRSummary> results = null;

            _context.LoadStoredProc("[usp_getVADRSummary]")
                .WithSqlParam("assessment_id", assessmentId)
                .ExecuteStoredProc((handler) => { results = handler.ReadToList<usp_getVADRSummary>().ToList(); });
            return results;

        }

        public List<usp_getVADRSummaryByGoal> GetVADRSummaryByGoal(int assessmentId)
        {
            List<usp_getVADRSummaryByGoal> results = null;

            _context.LoadStoredProc("[usp_getVADRSummaryByGoal]")
                .WithSqlParam("assessment_id", assessmentId)
                .ExecuteStoredProc((handler) => { results = handler.ReadToList<usp_getVADRSummaryByGoal>().ToList(); });
            return results;

        }

        public List<usp_getVADRSummaryByGoalOverall> GetVADRSummaryByGoalOverall(int assessmentId)
        {
            List<usp_getVADRSummaryByGoalOverall> results = null;

            _context.LoadStoredProc("[usp_getVADRSummaryByGoalOverall]")
                .WithSqlParam("assessment_id", assessmentId)
                .ExecuteStoredProc((handler) =>
                {
                    results = handler.ReadToList<usp_getVADRSummaryByGoalOverall>().ToList();
                });
            return results;
        }
    }
}