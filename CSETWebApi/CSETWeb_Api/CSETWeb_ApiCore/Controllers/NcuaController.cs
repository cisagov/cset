using Microsoft.AspNetCore.Mvc;
using System.IO;
using CSETWebCore.DataLayer.Model;
using Snickler.EFCore;
using System.Linq;
using System.Collections.Generic;
using System;
using System.Text;

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
        [Route("api/getMergeAnswers")]
        public List<ANSWER> GetMergeAnswers(int id)
        {
            var assessment = (from a in _context.ANSWER.AsQueryable()
                               where a.Assessment_Id == id
                               select a).ToList();
            
            return assessment;
        }
    }
}
    public class MergeDetail
    {
        public int AssessmentId { get; set; }
        public int QuestionId { get; set; }
        public string AnswerText { get; set; }
    }