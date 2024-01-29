//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Mvc;


namespace CSETWebCore.Api.Controllers
{
    public class MaturityC2M2Controller : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;

        private const int _c2m2ModelId = 12;


        /// <summary>
        /// Constructor.
        /// </summary>
        public MaturityC2M2Controller(
            CSETContext context,
            ITokenManager tokenManager,
            IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness,
            IReportsDataBusiness reports)
        {
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/maturitystructure/c2m2")]
        public IActionResult GetQuestions()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructureAsXml(assessmentId, true);

            var json = Helpers.CustomJsonWriter.Serialize(x.Root);
            return Ok(json);
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/c2m2/donutheatmap")]
        public IActionResult GetDonuts()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz1 = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var model = biz1.GetMaturityStructureForModel(_c2m2ModelId, assessmentId);

            var biz2 = new C2M2Business();
            var response = biz2.DonutsAndHeatmap(model);

            return Ok(response);
        }


        [HttpGet]
        [Route("api/c2m2/questionTable")]
        public IActionResult GetQuestionGrid()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz1 = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var model = biz1.GetMaturityStructureForModel(_c2m2ModelId, assessmentId);

            var biz2 = new C2M2Business();
            var response = biz2.QuestionTables(model);

            return Ok(response);
        }
    }
}
