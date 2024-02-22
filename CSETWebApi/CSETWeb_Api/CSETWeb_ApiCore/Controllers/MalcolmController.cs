//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Malcolm;
using CSETWebCore.Api.Error;
using CSETWebCore.Business.Diagram;
using CSETWebCore.Business.Merit;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Malcolm;
using CSETWebCore.Model.Malcolm;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing.Constraints;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Drawing;
using CSETWebCore.Interfaces;
using System.Threading.Tasks;
using System.Net;
using NPOI.HPSF;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace CSETWebCore.Api.Controllers
{
    public class MalcolmController : ControllerBase
    {
        private ITokenManager _token;
        private CSETContext _context;
        private IHttpContextAccessor _http;
        private IMalcolmBusiness _malcolm;
        private IDiagramManager _diagramManager;



        /// <summary>
        /// Controller
        /// </summary>
        public MalcolmController(ITokenManager token, CSETContext context, IHttpContextAccessor http, IMalcolmBusiness malcolm, IDiagramManager diagramManager)
        {
            _token = token;
            _context = context;
            _http = http;
            _malcolm = malcolm;
            _diagramManager = diagramManager;
        }

        [HttpGet]
        [Route("api/malcolm")]
        public async Task<IActionResult> GetMalcolmData(string IPAddress)
        {
            /**
             * Get Malcom data from the malcom server and import it. 
             *
             **/
            try
            {
                int assessmentId = (int)_token.PayloadInt(Constants.Constants.Token_AssessmentId);
                List<MalcolmData> processedData = await _malcolm.GetDataFromMalcomInstance(IPAddress);
                _diagramManager.CreateMalcolmDiagram(assessmentId, processedData);
                return Ok();
            }
            catch(Exception ex)
            {
                if(ex.InnerException == null)
                {
                    List<MalcolmUploadError> errors = new List<MalcolmUploadError>();
                    MalcolmUploadError error = new MalcolmUploadError(IPAddress, 400, ex.Message);
                    errors.Add(error);
                    return Ok(errors);
                }
                else if(ex.InnerException.Message== "A task was canceled.")
                {
                    List<MalcolmUploadError> errors = new List<MalcolmUploadError>();
                    MalcolmUploadError error = new MalcolmUploadError(IPAddress, 400, "Could not contact the Malcolm host.\nCheck to see that Malcolm is available to and can be connected to from this computer.");
                    errors.Add(error);
                    return Ok(errors);
                }
                else
                {
                    List<MalcolmUploadError> errors = new List<MalcolmUploadError>();
                    MalcolmUploadError error = new MalcolmUploadError(IPAddress, 400, ex.Message);
                    errors.Add(error);
                    return Ok(errors);
                }
        

            }
        }

        [HttpPost]
        [Route("api/malcolm")]
        public IActionResult MapSourceToDestinationData()
        {
            int assessmentId = (int)_token.PayloadInt(Constants.Constants.Token_AssessmentId);
            var formFiles = HttpContext.Request.Form.Files;
            string fileName = "";
            string fileExtension = "";
            List<MalcolmUploadError> errors = new List<MalcolmUploadError>();
            List<MalcolmData> dataList = new List<MalcolmData>();

            foreach (FormFile file in formFiles)
            {
                try
                {
                    using (var stream = new MemoryStream())
                    {
                        fileName = file.FileName;
                        fileExtension = System.IO.Path.GetExtension(fileName);
                        if (fileExtension == ".json")
                        {
                            file.CopyTo(stream);
                            stream.Seek(0, SeekOrigin.Begin);
                            StreamReader sr = new StreamReader(stream);
                            string jsonString = sr.ReadToEnd();
                            dataList = _malcolm.ProcessMalcomData(jsonString);
                        }
                        else
                        {
                            MalcolmUploadError error = new MalcolmUploadError(fileName, 415, "files of type " + fileExtension + " are unsupported.");
                            errors.Add(error);
                        }
                    }
                }
                catch (Exception ex)
                {
                    MalcolmUploadError error = new MalcolmUploadError(fileName, 400, ex.Message);
                    errors.Add(error);
                }
            }

            if (errors.Count > 0)
            {
                return Ok(errors);
            }
            else
            {
                try
                {
                    List<MalcolmData> processedData = _malcolm.GetMalcolmJsonData(dataList);
                    _diagramManager.CreateMalcolmDiagram(assessmentId, processedData);
                    return Ok();
                }
                catch (Exception ex)
                {
                    List<MalcolmUploadError> errors2 = new List<MalcolmUploadError>();
                    MalcolmUploadError error2 = new MalcolmUploadError("General Error", 400, ex.Message);
                    errors2.Add(error2);
                    return Ok(errors2);
                }
            }
        }

        

        [HttpGet]
        [Route("api/getMalcolmAnswers")]
        public List<MALCOLM_ANSWERS> GetMalcolmAnswers()
        {
            int assessId = _token.AssessmentForUser();

            return _malcolm.GetMalcolmAnswers(assessId);
        }
    }


}
