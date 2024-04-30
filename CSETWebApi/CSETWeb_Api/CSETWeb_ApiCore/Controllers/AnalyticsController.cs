//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Analytics;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Question;
using CSETWebCore.Business.Question;
using CSETWebCore.Interfaces.Analytics;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class AnalyticsController : ControllerBase
    {
        private readonly IRequirementBusiness _requirement;
        private readonly IAssessmentBusiness _assessment;
        private readonly ITokenManager _token;
        private readonly IDemographicBusiness _demographic;
        private readonly IQuestionRequirementManager _questionRequirement;
        private readonly IQuestionBusiness _question;
        private readonly IAnalyticsBusiness _analytics;

        public AnalyticsController(IRequirementBusiness requirement, IAssessmentBusiness assessment,
            ITokenManager token, IDemographicBusiness demographic,
            IQuestionRequirementManager questionRequirement, IQuestionBusiness question, IAnalyticsBusiness analytics)
        {
            _requirement = requirement;
            _assessment = assessment;
            _token = token;
            _demographic = demographic;
            _questionRequirement = questionRequirement;
            _question = question;
            _analytics = analytics;
        }

        /// <summary>
        /// Get analytic information
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/analytics/getAnalytics")]
        public IActionResult GetAnalytics()
        {
            var demographics = GetDemographics();
            var assessment = GetAnalyticsAssessment();
            assessment.Assets = demographics.AssetValue;
            assessment.Size = demographics.Size;
            assessment.IndustryId = demographics.IndustryId;
            assessment.SectorId = demographics.SectorId;

            return Ok(new Analytics
            {
                Assessment = assessment,
                Demographics = demographics,
                QuestionAnswers = GetQuestionsAnswers()
            });
        }

        [HttpGet]
        [Route("api/analytics/getAggregation")]
        public IActionResult GetAggregation()
        {
            int assessmentId = _token.AssessmentForUser();
            var agg = _analytics.GetAggregationAssessment(assessmentId);

            return Ok(agg);
        }

        private AnalyticsAssessment GetAnalyticsAssessment()
        {
            int assessmentId = _token.AssessmentForUser();
            var assessment = _assessment.GetAnalyticsAssessmentDetail(assessmentId);
            return assessment;
        }

        /// <summary>
        /// Returns an instance of Demographics for Anonymous export 
        /// </summary>        
        /// <returns></returns>
        private AnalyticsDemographic GetDemographics()
        {
            int assessmentId = _token.AssessmentForUser();
            return _demographic.GetAnonymousDemographics(assessmentId);
        }

        /// <summary>
        /// Returns questions/answers for current selected assessment
        /// </summary>
        /// <returns></returns>
        private List<AnalyticsQuestionAnswer> GetQuestionsAnswers()
        {
            int assessmentId = _token.AssessmentForUser();
            string applicationMode = _questionRequirement.GetApplicationMode(assessmentId);

            if (applicationMode.ToLower().StartsWith("questions"))
            {
                _question.SetQuestionAssessmentId(assessmentId);
                QuestionResponse resp = _question.GetQuestionListWithSet("*");
                return _question.GetAnalyticQuestionAnswers(resp).OrderBy(x => x.QuestionId).ToList();
            }
            else
            {
                _requirement.SetRequirementAssessmentId(assessmentId);
                QuestionResponse resp = _requirement.GetRequirementsList();
                return _question.GetAnalyticQuestionAnswers(resp).OrderBy(x => x.QuestionId).ToList();
            }
        }
    }
}
