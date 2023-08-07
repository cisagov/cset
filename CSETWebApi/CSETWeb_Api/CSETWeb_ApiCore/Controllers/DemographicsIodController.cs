//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Demographic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Demographic;
using Microsoft.AspNetCore.Mvc;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DemographicsIodController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private CSETContext _context;

        public DemographicsIodController(ITokenManager token, IAssessmentBusiness assessment,
            IDemographicBusiness demographic, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _context = context;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext2")]
        public IActionResult GetExtended2()
        {
            var assessmentId = _token.AssessmentForUser();

            var mgr = new DemographicIodBusiness();
            var response = mgr.GetDemographics(assessmentId, _context);
            return Ok(response);
        }


        /// <summary>
        /// Persists extended demographics.
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/demographics/ext")]
        public IActionResult PostExtended2([FromBody] DemographicIod demographics)
        {
            demographics.AssessmentId = _token.AssessmentForUser();

            var mgr = new DemographicIodBusiness();
            mgr.SaveDemographics(demographics);

            return Ok();
        }
    }
}
