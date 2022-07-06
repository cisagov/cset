using Microsoft.AspNetCore.Mvc;
using System.IO;
using CSETWebCore.DataLayer.Model;
using System.Linq;
using System.Collections.Generic;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using Snickler.EFCore;


namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class NcuaController
    {
        private CSETContext _context;
        
        public NcuaController(CSETContext context)
        {
            _context = context;
        }

        [HttpGet]
        [Route("api/isExaminersModule")]
        public bool isExaminersModule()
        {
            string currentDir = Directory.GetCurrentDirectory();
            string fileLocation = Path.Combine(currentDir, @"NCUA-EXAMINER-TOOL");

            return (File.Exists(fileLocation));
        }

        [HttpGet]
        [Route("api/getMergeData")]
        public IList<Get_Merge_ConflictsResult> GetMergeAnswers(int assessmentOneId, int assessmentTwoId)
        {
           return _context.Get_Merge_Conflicts(assessmentOneId, assessmentTwoId); 
        }
    }
}