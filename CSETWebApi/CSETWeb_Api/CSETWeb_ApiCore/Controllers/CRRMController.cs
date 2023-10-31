using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.Helpers;
using System;
using System.IO;

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
        [Route("api/crrm/exportAllAccessKeyAssessments")]
        public IActionResult GetAssessments()
        {

            try
            {
                // determine extension (.csetw, .acet)
                string ext = IOHelper.GetExportFileExtension("CSET");
                AssessmentExportManager exportManager = new AssessmentExportManager(_context);
                Stream assessmentsExportArchive = exportManager.ExportAllAccessKeyAssessments(ext);

                return File(assessmentsExportArchive, "application/octet-stream", "AccessKeyAssessments.zip");
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                return StatusCode(500, "There was an issue exporting all access key assessments");
            }

        }
    }
}
