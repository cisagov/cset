using Microsoft.AspNetCore.Mvc;
using System;
using CSETWebCore.Api.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Schema;

namespace CSETWebCore.Api.Controllers
{
    
    [ApiController]
    public class SchemaController : ControllerBase
    {
        [HttpGet]
        [Route("api/Schema")]
        public IActionResult Get()
        {
            try
            {
                var settings = new NJsonSchema.Generation.JsonSchemaGeneratorSettings() { FlattenInheritanceHierarchy = true };
                var schema = NJsonSchema.JsonSchema.FromType<ExternalStandard>(settings);
                return Ok(JsonConvert.DeserializeObject(schema.ToJson()));
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
