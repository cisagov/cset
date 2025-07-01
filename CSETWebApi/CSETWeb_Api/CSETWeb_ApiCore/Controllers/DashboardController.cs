//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Dashboard;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Dashboard.BarCharts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class DashboardController : ControllerBase
    {
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name="tokenManager"></param>
        public DashboardController(CSETContext context, ITokenManager tokenManager, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _tokenManager = tokenManager;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// Returns the normalized values for the model's 
        /// answer options.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistrib/normalized")]
        public IActionResult GetNormalizedAnswerDistribution([FromQuery] int modelIds)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new DashboardChartBusiness(assessmentId, _context, _assessmentUtil, _adminTabBusiness);
            var resp = biz.GetAnswerDistributionNormalized(modelIds);

            return Ok(resp);
        }



        /// <summary>
        /// Returns a composite of the normalized values for the answer options in all specified models.
        /// The modelIds parameter should be delimited with vertical bar (|) characters, e.g., modelIds=23|24|25
        /// answer options.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistribs/normalized")]
        public IActionResult GetNormalizedAnswerDistribution([FromQuery] string modelIds)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            List<int> modelIdList = modelIds.Split('|').Select(x => int.Parse(x)).ToList();

            var biz = new DashboardChartBusiness(assessmentId, _context, _assessmentUtil, _adminTabBusiness);


            // build a composite of all models
            List<NameValue> composite = new();

            foreach (int modelId in modelIdList)
            {
                var answerDistrib = biz.GetAnswerDistributionNormalized(modelId);
                foreach(NameValue pair in answerDistrib)
                {
                    composite.Add(new NameValue() { Name = pair.Name, Value = pair.Value });
                }
            }


            // average composite answers for the final result
            List<NameValue> resp = new();
            var answerOptions = composite.Select(x => x.Name).Distinct();
            foreach(string opt in answerOptions)
            {
                resp.Add(new NameValue() { Name = opt, Value = composite.FindAll(x => x.Name == opt).Select(x => x.Value).Average() });
            }


            return Ok(resp);
        }


        /// <summary>
        /// Returns the normalized values for the model's 
        /// answer options.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistrib/domain")]
        public IActionResult GetAnswerDistributionByDomain([FromQuery] int modelId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new DashboardChartBusiness(assessmentId, _context, _assessmentUtil, _adminTabBusiness);
            var resp = biz.GetAnswerDistributionByDomain(modelId);

            return Ok(resp);
        }
    }
}
