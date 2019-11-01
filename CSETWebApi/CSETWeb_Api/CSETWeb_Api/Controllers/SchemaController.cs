//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NJsonSchema;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;

namespace CSETWeb_Api.Controllers
{
    public class SchemaController : ApiController
    {
        public HttpResponseMessage Get()
        {
            try
            {
                var settings = new NJsonSchema.Generation.JsonSchemaGeneratorSettings() { FlattenInheritanceHierarchy = true };
                var schema = NJsonSchema.JsonSchema.FromType<ExternalStandard>(settings);
                return Request.CreateResponse(JsonConvert.DeserializeObject(schema.ToJson()));
            }
            catch(Exception e)
            {
                throw e;
            }
        }

    }

}


