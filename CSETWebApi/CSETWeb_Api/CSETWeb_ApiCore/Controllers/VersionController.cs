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
using DocumentFormat.OpenXml.Bibliography;

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
        public IActionResult getVersionNumber()
        {
            var version = _context.CSET_VERSION
                 .OrderByDescending(v => v.Id)
                .Take(1)
                .FirstOrDefault();
            if (version != null)
            {
                if (version.Cset_Version1 == null)
                {
                    return Ok(version);
                }

                if (version.Cset_Version1.Any())
                {
                    var versionNumberstr = version.Cset_Version1.Split('.').Select(int.Parse).ToList();
                    var versionNumber = new CsetVersionResponse();

                    versionNumber.MajorVersion = versionNumberstr[0];
                    versionNumber.MinorVersion = versionNumberstr[1];
                    versionNumber.Patch = versionNumberstr[2];
                    versionNumber.Build = versionNumberstr[3];
                    
                    return Ok(versionNumber);
                }
                else
                {
                    return Ok(version);
                }
            }

            return Ok(new CsetVersionResponse
            {
                MajorVersion = 0,
                MinorVersion = 0,
                Patch = 0,
                Build = 0
            });
        }

    }
    }


