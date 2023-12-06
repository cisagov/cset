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
        [Route("api/crrm/bulkExportAssessments")]
        public IActionResult BulkExportAssessments(Guid[] guidsToExport)
        {
            try
            {
                // determine extension (.csetw, .acet)
                string ext = IOHelper.GetExportFileExtension("CSET");
                AssessmentExportManager exportManager = new AssessmentExportManager(_context);
                MemoryStream assessmentsExportArchive = exportManager.BulkExportAssessmentsbyGuid(guidsToExport, ext);

                if (assessmentsExportArchive == null) 
                {
                    return StatusCode(404, "No Assessments with the provided GUIDs were found for export.");
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
