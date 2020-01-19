using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSET_Main.Data.AssessmentData;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;

namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class AnalyticsController : ApiController
    {
        /// <summary>
        /// Returns an instance of Demographics for Anonymous export 
        /// </summary>        
        /// <returns></returns>
        [HttpGet]
        [Route("api/analyitcs/getDemographics")]
        public IHttpActionResult GetDemographics()
        {
            int assessmentId = Auth.AssessmentForUser();
            AssessmentManager assessmentManager = new AssessmentManager();
            return Ok(assessmentManager.GetAnonymousDemographics(assessmentId));
        }

        [HttpGet]
        [Route("api/analytics/getQuestionsAnswers")]
        public IHttpActionResult GetQuestionsAnswers()
        {
            int assessmentId = Auth.AssessmentForUser();
            var questionsController = new QuestionsController();
            string applicationMode = questionsController.GetApplicationMode(assessmentId);
            QuestionsManager qm = new QuestionsManager(assessmentId);

            if (applicationMode.ToLower().StartsWith("questions"))
            {
                QuestionResponse resp = qm.GetQuestionList("*");
                return Ok(qm.GetAnalyticQuestionAnswers(resp));
            }
            else
            {
                RequirementsManager rm = new RequirementsManager(assessmentId);
                QuestionResponse resp = rm.GetRequirementsList();
                return Ok(qm.GetAnalyticQuestionAnswers(resp));
            }
        }

        
    }
}
