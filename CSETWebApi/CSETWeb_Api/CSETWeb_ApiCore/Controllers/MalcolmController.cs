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

namespace CSETWebCore.Api.Controllers
{
    public class MalcolmController : ControllerBase
    {
        private ITokenManager _token;
        private CSETContext _context;
        private IHttpContextAccessor _http;
        private IMalcolmBusiness _malcolm;



        /// <summary>
        /// Controller
        /// </summary>
        public MalcolmController(ITokenManager token, CSETContext context, IHttpContextAccessor http, IMalcolmBusiness malcolm)
        {
            _token = token;
            _context = context;
            _http = http;
            _malcolm = malcolm;
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
                        MalcolmData data = new MalcolmData();

                        if (fileExtension == ".json")
                        {
                            file.CopyTo(stream);
                            stream.Seek(0, SeekOrigin.Begin);
                            StreamReader sr = new StreamReader(stream);
                            string jsonString = sr.ReadToEnd();

                            /* New json file schema differed from what we were originally given */
                            jsonString = jsonString.Replace("source.ip","values");
                            jsonString = jsonString.Replace("source.device.role", "values");
                            jsonString = jsonString.Replace("destination.ip", "values");
                            jsonString = jsonString.Replace("destination.device.role", "values");

                            data = JsonConvert.DeserializeObject<MalcolmData>(jsonString);
                            dataList.Add(data);
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
                DiagramManager diagramManager = new DiagramManager(_context);
                List<MalcolmData> processedData = new MalcolmBusiness(_context).GetMalcolmJsonData(dataList);
                diagramManager.CreateMalcolmDiagram(assessmentId, processedData);
                return Ok();
            }
        }
    }


}
