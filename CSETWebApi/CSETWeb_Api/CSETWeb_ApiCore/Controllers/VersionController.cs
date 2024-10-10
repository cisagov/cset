using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Interfaces.Version;
using CSETWebCore.Business.Version;
using Microsoft.AspNetCore.Mvc;
using NLog;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CSETWebCore.Api.Controllers
{
    public class VersionController : Controller
    {
        private readonly IVersionBusiness _versionBusiness;
        private readonly CSETContext _context;
        //IVersionBusiness versionBusiness


        public VersionController(CSETContext context, IVersionBusiness versionBusiness)
        {
            _context = context;

            _versionBusiness = versionBusiness;

        }


        [HttpGet]
        [Route("api/version")]
        public IActionResult GetCsetVersion()
        {
            try
            {
                var v = _versionBusiness.GetVersionNumber();
                return Ok(v);
            }
            catch (Exception exc)
            {
                var logToDb = LogManager.GetCurrentClassLogger();
                logToDb.Error(exc.ToString());
                return Ok(exc.ToString());
            }
        }
    }
}