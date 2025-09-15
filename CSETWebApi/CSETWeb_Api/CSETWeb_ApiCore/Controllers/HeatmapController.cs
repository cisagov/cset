using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System;
using CSETWebCore.Business.Authorization;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class HeatmapController : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly Hooks _hooks;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IReportsDataBusiness _reports;


        /// <summary>
        /// 
        /// </summary>
        public HeatmapController(ITokenManager tokenManager, CSETContext context, Hooks hooks, IAssessmentUtil assessmentUtil,
           IReportsDataBusiness reports)
        {
            _tokenManager = tokenManager;
            _context = context;
            _hooks = hooks;
            _assessmentUtil = assessmentUtil;
            _reports = reports;
        }


        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/heatmap")]
        public IActionResult GetModelHeatmap(int modelId)
        {
            int assessmentId = 0;

            try
            {
                assessmentId = _tokenManager.AssessmentForUser();
                _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

                // if the modelId is not provided, get the primary model for the assessment
                if (modelId == 0)
                {
                    var primaryModel = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
                    if (primaryModel != null)
                    {
                        modelId = primaryModel.model_id;
                    }
                }
            }
            catch (Exception)
            {
                // It's okay to call this controller method
                // without an assessment ID for the module content report
            }

         

            var biz2 = new HeatmapGenerator(_context, _assessmentUtil);
            var heatmap = biz2.GetHeatmap(assessmentId, modelId);

            return Ok(heatmap);
        }
    }
}
