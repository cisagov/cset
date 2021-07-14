using CSETWebCore.Model.AssessmentIO;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;

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
