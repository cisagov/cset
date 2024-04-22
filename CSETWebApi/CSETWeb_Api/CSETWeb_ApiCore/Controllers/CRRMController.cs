using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.Helpers;
using System;
using System.IO;
using CSETWebCore.Business.AssessmentIO.Import;
using CSETWebCore.Interfaces.Helpers;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// This controller will handle all interactions with the CRRM.
    /// </summary>
    public class CRRMController : Controller
    {
        private readonly CSETContext _context;

        public CRRMController(CSETContext context)
        {
            _context = context;
        }

        [HttpGet]
        [ApiKeyAuthorize]
        [Route("api/crrm/bulkExportAccessKeyAssessments")]
        public IActionResult BulkExportAccessKeyAssessments()
        {
            // This endpoint exports all access key assessments where the "ModifiedSinceLastExport" column is true.
            try
            {
                // determine extension (.csetw, .acet)
                string ext = IOHelper.GetExportFileExtension("CSET");
                AssessmentExportManager exportManager = new AssessmentExportManager(_context);

                Guid[] guidsToExport = _context.ACCESS_KEY_ASSESSMENT
                    .Include(aca => aca.Assessment)
                    .Where(aca => aca.Assessment.ModifiedSinceLastExport == true)
                    .Select(aca => aca.Assessment.Assessment_GUID).ToArray();

                MemoryStream assessmentsExportArchive = exportManager.BulkExportAssessments(guidsToExport, ext);

                if (assessmentsExportArchive == null) 
                {
                    return StatusCode(204);
                }

                return File(assessmentsExportArchive, "application/zip", "BulkAssessmentExport.zip");
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                return StatusCode(500, "There was an issue bulk exporting assessments");
            }
        }
    }
}
