//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Authorization;
using CSETWebCore.Business.ModuleIO;
using CSETWebCore.DataLayer;
using CSETWebCore.Helpers;
using CSETWebCore.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Model.AssessmentIO;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class SetsController : ControllerBase
    {
        private CSETContext _context;

        public SetsController(CSETContext context)
        {
            _context = context;
        }

        [HttpGet]
        [Route("api/sets")]
        public async Task<IActionResult> GetAllSets()
        {
           
                var sets = _context.SETS.Where(s => s.Is_Displayed ?? true)
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
                        var mp = new ModuleImporter(_context);
                        mp.ProcessStandard(externalStandard);
                    }
                    catch (Exception exc)
                    {
                        //CsetLogManager.Instance.LogErrorMessage("Exception thrown in HangfireExecutor.SaveImport(): \n{0}", exc.ToString());
                        //logger.Log("An error was encountered when adding the module to the database.  Please try again");
                        throw exc;
                    }

                    // var id = BackgroundJob.Enqueue(() => HangfireExecutor.SaveImport(externalStandard, null));
                    return Ok();
                    //response = Request.CreateResponse(new { id });
                }
                else
                {
                    return BadRequest(ModelState);
                    // response = Request.CreateErrorResponse(HttpStatusCode.BadRequest, ModelState);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
                // response = Request.CreateErrorResponse(HttpStatusCode.InternalServerError, ex.Message);
            }

           // return Ok(response);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="setName"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/sets/export/{setName}")]
        public async Task<IActionResult> Export(string setName)
        {
            var set = _context.SETS
                .Include(s => s.Set_Category_)
                .Include(s => s.REQUIREMENT_SETS)
                    .ThenInclude(r => r.Requirement_)
                        .ThenInclude(rf => rf.REQUIREMENT_REFERENCES)
                            .ThenInclude(gf => gf.Gen_File_)
                .Include(s => s.REQUIREMENT_SETS)
                    .ThenInclude(r => r.Requirement_)
                        .ThenInclude(r => r.REQUIREMENT_LEVELS)
                .Where(s => (s.Is_Displayed ?? false) && s.Set_Name == setName).FirstOrDefault();

            if (set == null)
            {
               BadRequest($"A Set named '{setName}' was not found.");
            }

            return Ok(set.ToExternalStandard());
        }
    }
}
