//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System.IO;
using CSETWebCore.DataLayer.Model;
using System.Linq;
using System.Collections.Generic;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using Snickler.EFCore;
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Assessment;
using CSETWebCore.Business.Question;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class NcuaController : ControllerBase
    {
        public CSETContext _context;

        public NcuaController(CSETContext context)
        {
            _context = context;
        }


        [HttpGet]
        [Route("api/isExaminersModule")]
        public IActionResult isExaminersModule()
        {
            string currentDir = Directory.GetCurrentDirectory();
            string fileLocation = Path.Combine(currentDir, @"NCUA-EXAMINER-TOOL");

            return Ok(System.IO.File.Exists(fileLocation));
        }


        [HttpGet]
        [Route("api/getQuestionText")]
        public IActionResult GetQuestionText([FromQuery] int modelId)
        {
            // Query DB for question text from modelId
            // Return list of question text
            return Ok();
        }


        [HttpGet]
        [Route("api/getMergeData")]
        public IList<Get_Merge_ConflictsResult> GetMergeAnswers([FromQuery] int id1, [FromQuery] int id2, [FromQuery] int id3, [FromQuery] int id4, [FromQuery] int id5,
                                                                [FromQuery] int id6, [FromQuery] int id7, [FromQuery] int id8, [FromQuery] int id9, [FromQuery] int id10)
        {
            return _context.Get_Merge_Conflicts(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10);
        }

        [HttpGet]
        [Route("api/getCreditUnionData")]
        public IList<Get_Assess_Detail_Filter_DataResult> GetCreditUnionData([FromQuery] string model)
        {
            return _context.Get_Assess_Detail_Filters(model);
        }
    }
}