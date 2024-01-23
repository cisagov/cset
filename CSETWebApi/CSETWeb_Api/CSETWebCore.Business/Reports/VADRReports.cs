//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////
using CSETWebCore.DataLayer.Manual;
using Snickler.EFCore;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;

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

        public List<usp_getVADRSummaryOverall> GetSummaryOverall(int assessmentId)
        {
            List<usp_getVADRSummaryOverall> results = null;

            _context.LoadStoredProc("[usp_getVADRSummaryOverall]")
                .WithSqlParam("assessment_id", assessmentId)
                .ExecuteStoredProc((handler) => { results = handler.ReadToList<usp_getVADRSummaryOverall>().ToList(); });
            return results;
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