//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Merit;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Malcolm;
using CSETWebCore.Model.Malcolm;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;

namespace CSETWebCore.Api.Controllers
{
    public class MalcolmController : ControllerBase
    {
        private ITokenManager _token;
        private CSETContext _context;
        private IHttpContextAccessor _http;
        private IJSONFileExport _json;
        private TextWriter jsonWriter;
        private IMalcolmBusiness _malcolm;



        /// <summary>
        /// Controller
        /// </summary>
        public MalcolmController(ITokenManager token, CSETContext context, IHttpContextAccessor http)
        {
            _token = token;
            _context = context;
            _http = http;
            //_malcolm = malcolm;
        }


        [HttpGet]
        [Route("api/malcolm")]
        public IActionResult MapSourceToDestinationData([FromQuery] string files)
        {
            string[] fileList = files.Split(',');
            //fileList = Directory.GetFiles("C:\\Users\\WINSMR\\Documents\\MalcolmJson");
            var malcolmDataList = new List<GenericInput>();

            try
            {
                foreach (string file in fileList)
                {
                    if (System.IO.File.Exists(file))
                    {
                        string jsonString = System.IO.File.ReadAllText(file);
                        var malcolmData = JsonConvert.DeserializeObject<GenericInput>(jsonString);

                        malcolmDataList.Add(malcolmData);
                    }
                }

                return Ok(malcolmDataList);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null; 
        }
    }
}
