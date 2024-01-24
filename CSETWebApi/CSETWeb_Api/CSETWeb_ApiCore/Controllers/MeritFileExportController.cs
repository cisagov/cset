//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Merit;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System;
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

        [HttpGet]
        [Route("api/getUncPath")]
        public IActionResult GetUncPath()
        {
            try
            {
                int assessmentId = _token.AssessmentForUser();
                string uncPathString = _json.GetUncPath(_context);

                MeritFileExport uncCarrier = new MeritFileExport
                {
                    data = uncPathString
                };

                return Ok(uncCarrier);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost]
        [Route("api/saveUncPath")]
        public IActionResult SaveUncPath([FromBody] MeritFileExport uncPathCarrier)
        {
            try
            {
                int assessmentId = _token.AssessmentForUser();
                _json.SaveUncPath(uncPathCarrier.data, _context);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet]
        [Route("api/doesMeritDirectoryExist")]
        public IActionResult DoesMeritDirectoryExist()
        {
            try
            {
                int assessmentId = _token.AssessmentForUser();
                string uncPathString = _json.GetUncPath(_context);

                return Ok(_json.DoesDirectoryExist(uncPathString));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost]
        [Route("api/doesMeritFileExist")]
        public IActionResult DoesMeritFileExist([FromBody] MeritFileExport jsonData)
        {
            try
            {
                int assessmentId = _token.AssessmentForUser();
                string uncPathString = _json.GetUncPath(_context);

                return Ok(_json.DoesFileExist(jsonData.guid + ".json", uncPathString));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [HttpPost]
        [Route("api/newMeritFile")]
        public IActionResult NewMeritFile([FromBody] MeritFileExport jsonData)
        {
            try
            {


                int assessmentId = _token.AssessmentForUser();

                string uncPathString = _json.GetUncPath(_context);

                string filename = jsonData.guid + ".json";

                if (_json.DoesFileExist(filename, uncPathString))
                {
                    return BadRequest("File " + filename + " already exists");
                }

                string data = jsonData.data;

                /// -get new guid
                /// -save to ASSESSMENT table
                /// -return back to client/user

                _json.SendFileToMerit(filename, data, uncPathString);

                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
            /// check for existance
            /// 
            /// if doesn't exist:
            /// brandNewMerit
            /// check for existance (again for safety)
            /// if doesn't exist, write to a new file (with the original guid as the file name)
            /// 

            /// else if does exists:
            /// prompt user if they want to duplicateMerit or overwriteMerit (or cancel)
            /// duplicateMerit
            /// generate a new guid, set the db's AssessmentGUID to the new one, 
            /// and write to a new file (with the new guid as the file name)
            /// return new guid back to client
            /// overwriteMerit
            /// overwrite file (no need to check for existance)
            /// cancel
            /// don't do anything

        }

        [HttpPost]
        [Route("api/overrideMeritFile")]
        public IActionResult OverrideMeritFile([FromBody] MeritFileExport jsonData)
        {
            int assessmentId = _token.AssessmentForUser();

            string uncPathString = _json.GetUncPath(_context);
            string data = jsonData.data;
            string filename = jsonData.guid + ".json";
            string guid = jsonData.guid;

            //generate a new guid and change the AssessmentGUID in the db to the new one
            if (jsonData.overwrite == false)
            {
                Guid oldGuid = _json.GetAssessmentGuid(assessmentId, _context);
                Guid newGuid = Guid.NewGuid();

                if (jsonData.data.Contains(oldGuid.ToString()))
                {
                    data = jsonData.data.Replace(oldGuid.ToString(), newGuid.ToString());
                    //data = jsonData.data;
                }
                else
                {
                    return BadRequest("Could not find original GUID inside file.");
                }

                guid = newGuid.ToString();
                filename = newGuid + ".json";
                _json.SetNewAssessmentGuid(assessmentId, newGuid, _context);
            }

            _json.SendFileToMerit(filename, data, uncPathString);

            MeritFileExport guidCarrier = new MeritFileExport
            {
                guid = guid
            };


            return Ok(guidCarrier);
        }

    }
}
