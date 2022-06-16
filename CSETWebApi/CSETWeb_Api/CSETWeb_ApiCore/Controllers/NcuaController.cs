using Microsoft.AspNetCore.Mvc;
using System.IO;
using System;
using System.Text;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class NcuaController
    {
        public NcuaController()
        {

        }

        [HttpGet]
        [Route("api/isExaminersModule")]
        public bool isExaminersModule()
        {
            string currentDir = Directory.GetCurrentDirectory();
            string fileLocation = Path.Combine(currentDir, @"NCUA-EXAMINER-TOOL");

            return (File.Exists(fileLocation));
        } 
    }
}
