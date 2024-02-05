//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Mvc;
using System;
using NJsonSchema.NewtonsoftJson.Generation;


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
                var settings = new NewtonsoftJsonSchemaGeneratorSettings() { FlattenInheritanceHierarchy = true };

                StandardSchemaProcessor.dbContext = _context;
                var schema = NJsonSchema.JsonSchema.FromType<ExternalStandard>(settings);
                var schemaJson = schema.ToJson();
                return Ok(schemaJson);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
