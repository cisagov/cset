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

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CSETWebCore.Api.Controllers
{
    [Route("api/version")]
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
        [Route("getVersionNumber")]
        public IActionResult getVersionNumber()
        {
            var versionResponse = _versionBusiness.getversionNumber();
            return Ok(versionResponse);
        }

    }
}