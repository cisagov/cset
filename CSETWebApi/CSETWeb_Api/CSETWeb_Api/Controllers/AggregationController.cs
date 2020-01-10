//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using BusinessLogic;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class AggregationController : ApiController
    {
        /// <summary>
        /// Returns a list of aggregations that the current user is allowed to see.
        /// The user must be authorized to view all assessments involved in the aggregation.
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/getaggregations")]       
        public List<Aggregation> GetAggregations([FromUri] string mode)
        {
            // Get the current userid to set as the Assessment creator and first attached user
            int currentUserId = Auth.GetUserId();

            var manager = new BusinessLogic.AggregationManager();
            return manager.GetAggregations(mode, currentUserId);
        }


        [CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/getassessments")]
        public AssessmentListResponse GetAssessmentsForAggregation([FromUri] int aggregationId)
        {
            var manager = new BusinessLogic.AggregationManager();
            return manager.GetAssessmentsForAggregation(aggregationId);
        }


        [HttpPost]
        [Route("api/aggregation/standardgrid")]
        public void GetAssessmentStandardGrid([FromUri] int aggregationId)
        {
            var manager = new BusinessLogic.AggregationManager();
            manager.GetAssessmentStandardGrid(aggregationId);
        }



        //////////////////////////////////////////
        /// Merge
        //////////////////////////////////////////

        [CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/getanswers")]
        public MergeStructure GetAnswers()
        {
            var aggreg = new BusinessLogic.AggregationManager();
            return aggreg.GetAnswers(new List<int>() { 4, 5 });
        }


        /// <summary>
        /// Sets a single answer text into the COMBINED_ANSWER table.
        /// </summary>
        [CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/setmergeanswer")]
        public void SetMergeAnswer([FromUri] int answerId, [FromUri] string answerText)
        {
            var aggreg = new BusinessLogic.AggregationManager();
            aggreg.SetMergeAnswer(answerId, answerText);
        }
    }
}
