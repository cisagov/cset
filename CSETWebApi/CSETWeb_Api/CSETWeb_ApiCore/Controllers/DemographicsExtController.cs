//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Demographic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Demographic;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using CSETWebCore.Business.Demographic.Export;
using CSETWebCore.Business.Demographic.DemographicIO;
using CSETWebCore.Helpers;
using Microsoft.AspNetCore.Http;
using System.IO;
using CSETWebCore.Business.Demographic.Import;
using CSETWebCore.Business.AssessmentIO.Import;


namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DemographicsExtController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private CSETContext _context;

        public DemographicsExtController(ITokenManager token, IAssessmentBusiness assessment, IDemographicBusiness demographic, CSETContext context)
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

            var mgr = new DemographicExtBusiness(_context);
            var response = mgr.GetDemographics(assessmentId);
            return Ok(response);
        }


        [HttpGet]
        [Route("api/demographics/ext2/subsectors/{id}")]
        public IActionResult GetSubsectors(int id)
        {
            var mgr = new DemographicExtBusiness(_context);
            var response = mgr.GetSubsectors(id);
            return Ok(response);
        }


        /// <summary>
        /// Persists extended demographics.
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/demographics/ext2")]
        public IActionResult PostExtended2([FromBody] DemographicExt demographics)
        {
            demographics.AssessmentId = _token.AssessmentForUser();
            var userid = _token.GetCurrentUserId();

            var mgr = new DemographicExtBusiness(_context);
            mgr.SaveDemographics(demographics, userid ?? 0);


            return Ok();
        }



        /// <summary>
        /// Persists a single extended demographics value.
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/demographics/ext3")]
        public IActionResult PostExtended3([FromQuery] string name, [FromQuery] string val, [FromQuery] string t)
        {
            int assessmentId = _token.AssessmentForUser();

            var mgr = new DemographicExtBusiness(_context);
            if (val == "0: 0" | val == "0: null")
            {
                val = "0"; 
            }
            mgr.SaveX(assessmentId, name, val, t);

            return Ok();
        }

      

        [HttpGet]
        [Route("api/demographics/export")]
        public IActionResult ExportDemographic([FromQuery] string token)
        {
            try
            {
                _token.SetToken(token);

                int assessmentId = _token.AssessmentForUser(token);

                string ext = ".json";

                DemographicsExportFile result = new DemographicsExportManager(_context).ExportDemographics(assessmentId, ext);

                return File(result.FileContents, "application/octet-stream", result.FileName);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }
    }
}
