using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Question;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.Elfie.Model.Map;
using System.Collections.Generic;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class CieController : ControllerBase
    {
        public CSETContext _context;

        public CieController(CSETContext context)
        {
            _context = context;
        }

        [HttpGet]
        [Route("api/getCieMergeData")]
        public IList<Get_Merge_ConflictsResult> GetCieMergeAnswers([FromQuery] int id1, [FromQuery] int id2, [FromQuery] int id3, [FromQuery] int id4, [FromQuery] int id5,
                                                                [FromQuery] int id6, [FromQuery] int id7, [FromQuery] int id8, [FromQuery] int id9, [FromQuery] int id10)
        {
            return _context.Get_Cie_Merge_Conflicts(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10);
        }

        [HttpPost]
        [Route("api/saveNewDocumentsForMerge")]
        public IActionResult SaveNewDocumentsForMerge([FromBody] List<DocumentWithAnswerId> documents)
        {
            return Ok();
        }
    }
}
