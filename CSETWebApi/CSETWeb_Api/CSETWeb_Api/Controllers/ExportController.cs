//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.Helpers;
using DataLayerCore.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using Microsoft.EntityFrameworkCore;

namespace CSETWeb_Api.Controllers
{
    public class ExportController : ApiController
    {
        public async Task<HttpResponseMessage> Get()
        {
            return await Task.Run(() =>
            {
                using (var db = new CSET_Context())
                {
                    var sets = db.SETS.Where(s => s.Is_Displayed ?? true).ToList()
                                        .Select(s => new { Name = s.Full_Name, SetName = s.Set_Name }).OrderBy(s => s.Name)
                                        .ToList();
                    return Request.CreateResponse(sets);
                }
            });
        }
        [HttpGet]
        [Route("api/export/{setName}")]
        public async Task<HttpResponseMessage> Get(string setName)
        {
            return await Task.Run(() =>
            {
                using (var db = new CSET_Context())
                {
                    var set = db.SETS
                    .Include(s => s.Set_Category_)
                    .Where(s => s.Is_Displayed ?? true && s.Set_Name == setName).FirstOrDefault().ToExternalStandard();
                    return Request.CreateResponse(set);
                }
            });
        }
    }
}


