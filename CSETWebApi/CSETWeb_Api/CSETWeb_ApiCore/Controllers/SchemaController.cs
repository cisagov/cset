using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.DataLayer;
using Microsoft.AspNetCore.Mvc;
using System;


namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class SchemaController : ControllerBase
    {
        private readonly CSETContext _context;

        /// <summary>
        /// Constructor.
        /// </summary>
        public SchemaController(CSETContext context)
        {
            _context = context;
        }


        [HttpGet]
        [Route("api/Schema")]
        public IActionResult Get()
        {
            try
            {
                var settings = new NJsonSchema.Generation.JsonSchemaGeneratorSettings() { FlattenInheritanceHierarchy = true };

                StandardSchemaProcessor.dbContext = _context;
                var schema = NJsonSchema.JsonSchema.FromType<ExternalStandard>(settings);
                var schemaJson = schema.ToJson();

                var x = 1;

                /// var sss =  JsonConvert.DeserializeObject(schemaJson);
                return Ok(schemaJson);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
