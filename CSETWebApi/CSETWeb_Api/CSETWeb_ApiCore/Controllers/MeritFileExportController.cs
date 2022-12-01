//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Merit;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Aggregation;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Aggregation;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Linq;


namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class MeritFileExportController : ControllerBase
    {
        private readonly CSETContext _context;
        private readonly ITokenManager _token;
        private readonly IJSONFileExport _json;

        public MeritFileExportController(CSETContext context, ITokenManager token, IJSONFileExport json)
        {
            _context = context;
            _token = token;
            _json = json;
        }


        /**
         - 
         
         */

        //[HttpGet]
        //[Route("api/reports/acet/sendFileToMerit")]
        //public IActionResult SendFileToMerit()
        //{
        //    int assessmentId = _token.AssessmentForUser();
        //    _report.SetReportsAssessmentId(assessmentId);
        //    _report.SendFileToMerit();
        //    return Ok();
        //}

        [HttpPost]
        [Route("api/doesMeritFileExist")]
        public IActionResult DoesMeritFileExist([FromBody] MeritFileExport jsonData)
        {
            int assessmentId = _token.AssessmentForUser();

            bool exists = false; //change this to test

            return Ok(exists);
        }

        [HttpPost]
        [Route("api/newMeritFile")]
        public IActionResult NewMeritFile([FromBody] MeritFileExport jsonData)
        {
            int assessmentId = _token.AssessmentForUser();

            var uncPath = _context.GLOBAL_PROPERTIES.Where(x => x.Property == "NCUAMeritExportPath").ToList();
            string uncPathString = uncPath[0].Property_Value.ToString();
            string data = jsonData.data;
            string filename = jsonData.fileName;

            bool overwrite = false;

            _json.SendFileToMerit(filename, data, uncPathString, overwrite);

            return Ok();
        }

        [HttpPost]
        [Route("api/overwriteMeritFile")]
        public IActionResult OverwriteMeritFile([FromBody] MeritFileExport jsonData)
        {
            int assessmentId = _token.AssessmentForUser();
            
            var uncPath = _context.GLOBAL_PROPERTIES.Where(x => x.Property == "NCUAMeritExportPath").ToList();
            string uncPathString = uncPath[0].Property_Value.ToString();
            string data = jsonData.data;
            string filename = jsonData.fileName;

            bool overwrite = true;

            _json.SendFileToMerit(filename, data, uncPathString, overwrite);

            return Ok();
        }
    }
}
