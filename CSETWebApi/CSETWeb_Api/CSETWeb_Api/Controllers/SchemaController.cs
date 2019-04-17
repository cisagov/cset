//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using Newtonsoft.Json;
using NJsonSchema;
using NJsonSchema.Generation.TypeMappers;
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
        public async Task<HttpResponseMessage> Get()
        {
            var schema = await JsonSchema4.FromTypeAsync<ExternalStandard>(new NJsonSchema.Generation.JsonSchemaGeneratorSettings() { FlattenInheritanceHierarchy = true });
            return Request.CreateResponse(JsonConvert.DeserializeObject(schema.ToJson()));
        }

    }

}


