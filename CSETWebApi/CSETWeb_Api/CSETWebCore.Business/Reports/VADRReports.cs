//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
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

        public List<usp_getRRASummaryOverall> GetSummaryOverall(int assessmentId)
        {
            List<usp_getRRASummaryOverall> results = null;

            _context.LoadStoredProc("[usp_getVADRSummaryOverall]")
                .WithSqlParam("assessment_id", assessmentId)
                .ExecuteStoredProc((handler) => { results = handler.ReadToList<usp_getRRASummaryOverall>().ToList(); });
            return results;
        }

        public List<usp_getRRASummary> GetVADRSummary(int assessmentId)
        {
            List<usp_getRRASummary> results = null;

            _context.LoadStoredProc("[usp_getRRASummary]")
                .WithSqlParam("assessment_id", assessmentId)
                .ExecuteStoredProc((handler) => { results = handler.ReadToList<usp_getRRASummary>().ToList(); });
            return results;

        }

        public List<usp_getRRASummaryByGoal> GetVADRSummaryByGoal(int assessmentId)
        {
            List<usp_getRRASummaryByGoal> results = null;

            _context.LoadStoredProc("[usp_getRRASummaryByGoal]")
                .WithSqlParam("assessment_id", assessmentId)
                .ExecuteStoredProc((handler) => { results = handler.ReadToList<usp_getRRASummaryByGoal>().ToList(); });
            return results;

        }

        public List<usp_getRRASummaryByGoalOverall> GetVADRSummaryByGoalOverall(int assessmentId)
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