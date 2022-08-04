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
using System.Threading.Tasks;

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

        public AnalyticsController(IRequirementBusiness requirement, IAssessmentBusiness assessment,
            ITokenManager token, IDemographicBusiness demographic,
            IQuestionRequirementManager questionRequirement, IQuestionBusiness question)
        {
            _requirement = requirement;
            _assessment = assessment;
            _token = token;
            _demographic = demographic;
            _questionRequirement = questionRequirement;
            _question = question;
        }

        /// <summary>
        /// Get analytic information
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/analytics/getAnalytics")]
        public async Task<IActionResult> GetAnalytics()
        {
            var demographics = await GetDemographics();
            var assessment = await GetAnalyticsAssessment();
            assessment.Assets = demographics.AssetValue;
            assessment.Size = demographics.Size;
            assessment.IndustryId = demographics.IndustryId;
            assessment.SectorId = demographics.SectorId;

            return Ok(new Analytics
            {
                Assessment = assessment,
                Demographics = demographics,
                QuestionAnswers = await GetQuestionsAnswers()
            });
        }

        private async Task<AnalyticsAssessment> GetAnalyticsAssessment()
        {
            int assessmentId = await _token.AssessmentForUser();
            var assessment = await _assessment.GetAnalyticsAssessmentDetail(assessmentId);
            return assessment;
        }

        /// <summary>
        /// Returns an instance of Demographics for Anonymous export 
        /// </summary>        
        /// <returns></returns>
        private async Task<AnalyticsDemographic> GetDemographics()
        {
            int assessmentId = await _token.AssessmentForUser();
            return _demographic.GetAnonymousDemographics(assessmentId);
        }

        /// <summary>
        /// Returns questions/answers for current selected assessment
        /// </summary>
        /// <returns></returns>
        private async Task<List<AnalyticsQuestionAnswer>> GetQuestionsAnswers()
        {
            int assessmentId = await _token.AssessmentForUser();
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
                QuestionResponse resp = await _requirement.GetRequirementsList();
                return _question.GetAnalyticQuestionAnswers(resp).OrderBy(x => x.QuestionId).ToList();
            }
        }
    }
}
