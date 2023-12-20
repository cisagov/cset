//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.Business.Merit;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.Model.Malcolm;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using NPOI.XSSF.UserModel;
using NuGet.Protocol;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;

namespace CSETWebCore.Api.Controllers
{
    public class MalcolmController : ControllerBase
    {
        private ITokenManager _token;
        private CSETContext _context;
        private IHttpContextAccessor _http;
        private IJSONFileExport _json;
        private TextWriter jsonWriter;


        /// <summary>
        /// Controller
        /// </summary>
        public MalcolmController(ITokenManager token, CSETContext context, IHttpContextAccessor http)
        {
            _token = token;
            _context = context;
            _http = http;
        }


        [HttpGet]
        [Route("api/malcolm")]
        public IActionResult MapSourceToDestinationData()
        {
            try
            {
                //string text = System.IO.File.ReadAllText("C:\\Users\\WINSMR\\Downloads\\source_to_destination_ip.json");
                
                //GenericInput json = JsonConvert.DeserializeObject<GenericInput>(text);

                string[] files = Directory.GetFiles("C:\\Users\\WINSMR\\Documents\\MalcolmJson");
                var malcolmDataList = new List<GenericInput>();

                try
                {
                    foreach (string file in files)
                    {
                        string jsonString = System.IO.File.ReadAllText(file);
                        var malcolmData = JsonConvert.DeserializeObject<GenericInput>(jsonString);
                        //weatherData = model.AladinModel.ToList();

                        malcolmDataList.Add(malcolmData);
                    }
                }
                catch (Exception exc)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                }
                
                return Ok();
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }
    }
}
