using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSETWeb_Api.BusinessLogic.Models;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class AggregationController : ApiController
    {
        [HttpPost]
        [Route("api/aggregation/getanswers")]
        public MergeStructure GetAnswers()
        {
            var aggreg = new BusinessLogic.AggregationManager();
            return aggreg.GetAnswers(new List<int>() { 4, 5, 6 });
        }


        /// <summary>
        /// Sets a single answer text into the COMBINED_ANSWER table.
        /// </summary>
        [HttpPost]
        [Route("api/aggregation/answercombined")]
        public void SetAnswerCombined(int answerId, string answerText)
        {
            
        }
    }
}
