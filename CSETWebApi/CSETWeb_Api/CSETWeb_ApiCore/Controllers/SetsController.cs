//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.ModuleIO;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.Business.GalleryParser;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class SetsController : ControllerBase
    {
        private CSETContext _context;
        private readonly IGalleryEditor _galleryEditor;

        public SetsController(CSETContext context, IGalleryEditor galleryEditor)
        {
            _context = context;
            _galleryEditor = galleryEditor;
        }

        [HttpGet]
        [Route("api/sets")]
        public IActionResult GetAllSets()
        {
            var sets = _context.SETS.Where(s => s.Is_Displayed)
                .Select(s => new { Name = s.Full_Name, SetName = s.Set_Name })
                .OrderBy(s => s.Name)
                .ToArray();
            return Ok(sets);
        }


        /// <summary>
        /// Import new standards into CSET
        /// </summary>
        [HttpPost]
        [Route("api/sets/import")]
        public IActionResult Import([FromBody] ExternalStandard externalStandard)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    try
                    {
                        var mp = new ModuleImporter(_context, _galleryEditor);
                        mp.ProcessStandard(externalStandard);
                    }
                    catch (Exception exc)
                    {
                        NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                        throw;
                    }

                    return Ok();
                }
                else
                {
                    return BadRequest(ModelState);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="setName"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/sets/export/{setName}")]
        public IActionResult Export(string setName)
        {
            var set = _context.SETS
                .Include(s => s.Set_Category)
                .Include(s => s.REQUIREMENT_SETS)
                    .ThenInclude(r => r.Requirement)
                        .ThenInclude(rf => rf.REQUIREMENT_REFERENCES)
                            .ThenInclude(gf => gf.Gen_File)
                .Include(s => s.REQUIREMENT_SETS)
                    .ThenInclude(r => r.Requirement)
                        .ThenInclude(r => r.REQUIREMENT_LEVELS)
                .Where(s => (s.Is_Displayed) && s.Set_Name == setName).FirstOrDefault();

            if (set == null)
            {
                BadRequest($"A Set named '{setName}' was not found.");
            }

            return Ok(set.ToExternalStandard(_context));
        }
    }
}
