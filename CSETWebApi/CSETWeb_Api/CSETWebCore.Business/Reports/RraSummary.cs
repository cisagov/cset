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

        public List<usp_getRRASummaryOverall> GetSummaryOverall(int assessmentId)
        {
            List<usp_getRRASummaryOverall> results = null;

            _context.LoadStoredProc("[usp_getRRASummaryOverall]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<usp_getRRASummaryOverall>().ToList();
            });
            return results;
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