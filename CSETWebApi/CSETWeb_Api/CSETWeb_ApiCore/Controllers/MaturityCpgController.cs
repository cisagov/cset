//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;


namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class MaturityCpgController : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;



        /// <summary>
        /// 
        /// </summary>
        public MaturityCpgController(ITokenManager tokenManager, CSETContext context, IAssessmentUtil assessmentUtil,
    IAdminTabBusiness adminTabBusiness, IReportsDataBusiness reports)
        {
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
        }


        /// <summary>
        /// Returns the maturity grouping/question structure for an assessment.
        /// Specifying a query parameter of domainAbbreviation will limit the response
        /// to a single domain.
        /// </summary>
        [HttpGet]
        [Route("api/maturity/structure/cpg")]
        public IActionResult GetQuestions()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructure(assessmentId, true, lang);

            return Ok(x);
        }


        /// <summary>
        /// Returns the maturity grouping/question structure for an assessment.
        /// Specifying a query parameter of domainAbbreviation will limit the response
        /// to a single domain.
        /// </summary>
        [HttpGet]
        [Route("api/maturity/structure/cpg/bonus")]
        public IActionResult GetQuestionsForModel([FromQuery] int modelId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructure(assessmentId, true, lang, modelId);

            return Ok(x);
        }


        /// <summary>
        /// Returns the answer percentage distributions for each of the
        /// 8 CPG domains.
        /// </summary>
        [HttpGet]
        [Route("api/answerdistrib/cpg/domains")]
        public IActionResult GetAnswerDistribForDomains()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            var cpgBiz = new CpgBusiness(_context, lang);
            var resp = cpgBiz.GetAnswerDistribForDomains(assessmentId);

            return Ok(resp);
        }


        /// <summary>
        /// Returns the applicable SSG model ID (if any)
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ssg/modelid")]
        public IActionResult GetSsgModelId()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            var cpgBiz = new CpgBusiness(_context, lang);

            var ssgModelId = cpgBiz.DetermineSsgModel(assessmentId);

            return Ok(ssgModelId);
        }
    }
}
