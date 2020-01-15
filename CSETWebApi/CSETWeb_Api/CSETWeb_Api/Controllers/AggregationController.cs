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
using CSETWeb_Api.Helpers;

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


        //[CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/create")]
        public Aggregation CreateAggregation([FromUri] string mode)
        {
            var manager = new BusinessLogic.AggregationManager();
            return manager.CreateAggregation(mode);
        }


        //[CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/get")]
        public Aggregation GetAggregation([FromUri] int aggregationId)
        {
            var manager = new BusinessLogic.AggregationManager();
            return manager.GetAggregation(aggregationId);
        }


        //[CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/update")]
        public void UpdateAggregation([FromBody] Aggregation aggregation)
        {
            var manager = new BusinessLogic.AggregationManager();
            manager.SaveAggregationInformation(aggregation.AggregationId, aggregation);
        }


        //[CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/getassessments")]
        public AssessmentListResponse GetAssessmentsForAggregation([FromUri] int aggregationId)
        {
            var manager = new BusinessLogic.AggregationManager();
            return manager.GetAssessmentsForAggregation(aggregationId);
        }


        //[CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/saveassessmentselection")]
        public void SaveAssessmentSelection([FromBody] AssessmentSelection request)
        {

            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return;
            }

            var aggreg = new BusinessLogic.AggregationManager();
            aggreg.SaveAssessmentSelection((int)aggregationID, request.AssessmentId, request.Selected);
        }


        //[CSETAuthorize]
        [HttpPost]
        [Route("api/aggregation/saveassessmentalias")]
        public void SaveAssessmentAlias([FromBody] AssessmentSelection request)
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return;
            }

            var aggreg = new BusinessLogic.AggregationManager();
            aggreg.SaveAssessmentAlias((int)aggregationID, request.AssessmentId, request.Alias);
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
