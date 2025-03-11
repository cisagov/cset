//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;


namespace CSETWebCore.Api.Controllers
{   [CsetAuthorize]
    public class AggregationMaturityController : Controller
    {
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;



        /// <summary>
        /// CTOR
        /// </summary>
        public AggregationMaturityController(ITokenManager tokenManager, CSETContext context)
        {
            _context = context;
            _tokenManager = tokenManager;

        }


        /// <summary>
        /// Returns domain scores for the assessments in
        /// the aggregation.  Each maturity model
        /// is compared against other assessments that have 
        /// that model.  No cross-model comparisons are done.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/aggregation/analysis/maturity/compliance")]
        public IActionResult GetComplianceByModelAndDomain()
        {   
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }
            var amb = new AggregationMaturityBusiness(_context);
            var resp = amb.GetMaturityModelComplianceChart(aggregationID.Value);

            return Ok(resp);
        }
    }
}
