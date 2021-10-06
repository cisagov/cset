using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Api.Controllers
{
    public class FileUploadController : Controller
    {
        [HttpPost]
        [Route("/api/files/blob/create/")]
        public async Task<IActionResult> Upload()
        {

            return StatusCode(501);
        }
    }
}
