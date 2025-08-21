//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Dashboard;
using CSETWebCore.Business.Grouping;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class CreController : ControllerBase
    {
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly IAssessmentUtil _assessmentUtil;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name="tokenManager"></param>
        public CreController(CSETContext context, ITokenManager tokenManager, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _tokenManager = tokenManager;
            _assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// A more targeted way to build answer distribution series for the entire model.
        /// </summary>
        /// <param name="modelIds"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/chart/maturity/goalcount")]
        public IActionResult BuildDetailedAnswerDistribForModel([FromQuery] int modelId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new GroupingBusiness(assessmentId, _context);

            var selectedCount = biz.GetSelectionCountForModel(modelId);

            return Ok(selectedCount);
        }
    }
}
