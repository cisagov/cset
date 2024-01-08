//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Malcolm;
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
using System.Linq;

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
        public IActionResult MapSourceToDestinationData([FromQuery] string files)
        {
            return Ok(new MalcolmBusiness(_context).GetMalcolmJsonData());
            //return Ok(GetMalcolmJsonData());
        }

        public IEnumerable<GenericInput> GetMalcolmJsonData()
        {
            string[] files = Directory.GetFiles("C:\\Users\\WINSMR\\Documents\\MalcolmJson");
            var malcolmDataList = new List<GenericInput>();
            //var dict = new Dictionary<string, int>();
            try
            {
                foreach (string file in files)
                {
                    string jsonString = System.IO.File.ReadAllText(file);
                    var malcolmData = JsonConvert.DeserializeObject<GenericInput>(jsonString);

                    var dict = new Dictionary<string, int>();
                    dict = CreateDictionary(malcolmData.Values.Buckets, dict);
                    dict.OrderBy(a => a.Value);

                    malcolmDataList.Add(malcolmData);
                }

                return malcolmDataList;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }

        public Dictionary<string, int> CreateDictionary(List<Buckets> buckets, Dictionary<string, int> dict)
        {
            foreach (Buckets bucket in buckets)
            {
                if (bucket.Values != null)
                {
                    dict.TryAdd(bucket.Key, bucket.Values.Buckets.Count);
                    dict = CreateDictionary(bucket.Values.Buckets, dict);
                }
            }

            return dict;
        }
    }
}
