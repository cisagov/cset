//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Demographic.DemographicIO;
using CSETWebCore.Business.Demographic.Export;
using CSETWebCore.Business.Demographic.Import;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Mvc;
using System;


namespace CSETWebCore.Api.Controllers
{
    public class DemographicsExportController : ControllerBase
    {
        private ITokenManager _token;
        private CSETContext _context;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public DemographicsExportController(ITokenManager token, CSETContext context, IDemographicsImportManager demographicImportManager)
        {
            _token = token;
            _context = context;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/export")]
        public IActionResult ExportDemographic()
        {
            try
            {
                int assessmentId = _token.AssessmentForUser();
                DemographicsExportFile result = new DemographicsExportManager(_context).ExportDemographics(assessmentId);

                return File(result.FileContents, "application/octet-stream", result.FileName);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }
    }
}
