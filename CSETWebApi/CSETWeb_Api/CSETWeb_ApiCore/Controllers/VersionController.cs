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
    public class VersionController : Controller
    {
        private readonly IVersionBusiness _versionBusiness;
        private readonly CSETContext _context;
        //IVersionBusiness versionBusiness

        public VersionController(CSETContext context)
        {
            _context = context;

            //_versionBusiness = versionBusiness;

        }

        [HttpGet]
        [Route("api/version/getVersionNumber")]
        public CSET_VERSION getVersionNumber()
        {
            //var result = _versionBusiness.getversionNumber();
            //return result;
            var result = _context.CSET_VERSION
                 .OrderByDescending(v => v.Id)
                .Take(1)
                .FirstOrDefault();
            return result;
            
        }
        //[HttpPost]
        //[Route("api/saveNewVersionNumber")]
        //public IActionResult saveNewVersionNumber([FromBody] CSET_VERSION version)
        //{

        //    CSET_VERSION version = _context.CSET_VERSION.Find(version.Id);
        //    version.Cset_Version1 = updatedVersion.Cset_Version1;
        //    version.currentVersion = updatedVersion.currentVersion;
        //    _context.SaveChanges();
        //    //_versionBusiness.getVersion(version);
        //    return Ok();
        //}
    }
}

