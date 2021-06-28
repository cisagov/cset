//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessManagers.Analysis;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWeb_Api.Controllers
{
    public class RRASummary
    {
        
        private CSET_Context context;        
        public RRASummary(CSET_Context context)
        {
            this.context = context;
        }

        internal List<usp_getRRASummaryOverall> getSummaryOverall(CSET_Context context, int assessmentId)
        {
            List<usp_getRRASummaryOverall> results = null;

            context.LoadStoredProc("[usp_getRRASummaryOverall]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<usp_getRRASummaryOverall>().ToList();
            });
            return results;
        }

        internal List<usp_getRRASummary> getRRASummary(CSET_Context context, int assessmentId)
        {
            List<usp_getRRASummary> results = null;

            context.LoadStoredProc("[usp_getRRASummary]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<usp_getRRASummary>().ToList();
            });
            return results;

        }

        internal List<usp_getRRASummaryByGoal> getRRASummaryByGoal(CSET_Context context, int assessmentId)
        {
            List<usp_getRRASummaryByGoal> results = null;

            context.LoadStoredProc("[usp_getRRASummaryByGoal]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<usp_getRRASummaryByGoal>().ToList();
            });
            return results;

        }

        internal List<usp_getRRASummaryByGoalOverall> getRRASummaryByGoalOverall(CSET_Context context, int assessmentId)
        {
            List<usp_getRRASummaryByGoalOverall> results = null;

            context.LoadStoredProc("[usp_getRRASummaryByGoalOverall]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results = handler.ReadToList<usp_getRRASummaryByGoalOverall>().ToList();
            });
            return results;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        internal List<string> GetQuestions(CSET_Context context, int assessmentId)
        {
            List<string> results = new List<string>();
            return results;
        }
    }
}