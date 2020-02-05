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
    [CSETAuthorize]
    public class AggregationController : ApiController
    {
        /// <summary>
        /// Returns a list of aggregations that the current user is allowed to see.
        /// The user must be authorized to view all assessments involved in the aggregation.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/getaggregations")]
        public List<Aggregation> GetAggregations([FromUri] string mode)
        {
            // Get the current userid to set as the Assessment creator and first attached user
            int currentUserId = Auth.GetUserId();

            var manager = new BusinessLogic.AggregationManager();
            return manager.GetAggregations(mode, currentUserId);
        }


        [HttpPost]
        [Route("api/aggregation/create")]
        public Aggregation CreateAggregation([FromUri] string mode)
        {
            var manager = new BusinessLogic.AggregationManager();
            return manager.CreateAggregation(mode);
        }


        [HttpPost]
        [Route("api/aggregation/get")]
        public Aggregation GetAggregation()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var manager = new BusinessLogic.AggregationManager();
            return manager.GetAggregation((int)aggregationID);
        }


        [HttpPost]
        [Route("api/aggregation/update")]
        public void UpdateAggregation([FromBody] Aggregation aggregation)
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return;
            }

            var manager = new BusinessLogic.AggregationManager();
            manager.SaveAggregationInformation(aggregation.AggregationId, aggregation);
        }


        [HttpPost]
        [Route("api/aggregation/delete")]
        public void DeleteAggregation([FromUri] int aggregationId)
        {
            var manager = new BusinessLogic.AggregationManager();
            manager.DeleteAggregation(aggregationId);
        }


        [HttpPost]
        [Route("api/aggregation/getassessments")]
        public AssessmentListResponse GetAssessmentsForAggregation()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var manager = new BusinessLogic.AggregationManager();
            return manager.GetAssessmentsForAggregation((int)aggregationID);
        }


        [HttpPost]
        [Route("api/aggregation/saveassessmentselection")]
        public Aggregation SaveAssessmentSelection([FromBody] AssessmentSelection request)
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var aggreg = new BusinessLogic.AggregationManager();
            return aggreg.SaveAssessmentSelection((int)aggregationID, request.AssessmentId, request.Selected);
        }


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


        [HttpPost]
        [Route("api/aggregation/getmissedquestions")]
        public List<MissedQuestion> GetCommonlyMissedQuestions()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return new List<MissedQuestion>();
            }

            var manager = new BusinessLogic.AggregationManager();
            return manager.GetCommonlyMissedQuestions((int)aggregationID);
        }



        //////////////////////////////////////////
        /// Merge
        //////////////////////////////////////////

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
        [HttpPost]
        [Route("api/aggregation/setmergeanswer")]
        public void SetMergeAnswer([FromUri] int answerId, [FromUri] string answerText)
        {
            var aggreg = new BusinessLogic.AggregationManager();
            aggreg.SetMergeAnswer(answerId, answerText);
        }
    }
}
