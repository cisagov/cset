using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.Helpers;
using System.Linq;
using System;
using CSETWebCore.Model.AssessmentIO;
using System.Collections.Generic;

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
                var accessKeyAssessments = _context.ACCESS_KEY_ASSESSMENT.ToList();
                var assessments = _context.ASSESSMENTS.Where(a => accessKeyAssessments.Any(x => x.Assessment_Id == a.Assessment_Id));

                string fileExt = IOHelper.GetExportFileExtension("CSET");


                // export the assessments
                var exportManager = new AssessmentExportManager(_context);
                List<AssessmentExportFile> exportFiles = new List<AssessmentExportFile>();
                foreach (ASSESSMENTS a in assessments) 
                {
                    exportFiles.Add(exportManager.ExportAssessment(a.Assessment_Id, fileExt));
                }

                return File(result, "application/octet-stream", filename);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                return StatusCode(500, "There was an issue exporting all access key assessments");
            }

        }
    }
}
