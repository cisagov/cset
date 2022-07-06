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
        
        public NcuaController(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
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
        public List<Get_Merge_Conflicts> GetMergeAnswers(int assessmentOneId, int assessmentTwoId)
        {
            List<Get_Merge_Conflicts> response = null;
            _context.LoadStoredProc("[Get_Merge_Conflicts]")
                        .WithSqlParam("id1", assessmentOneId) 
                        .WithSqlParam("id2", assessmentTwoId)
                        .ExecuteStoredProc((handler) =>
                        {
                            var result = handler.ReadToList<Get_Merge_Conflicts>();
                            var labels = (from Get_Merge_Conflicts data in result
                                            orderby data.Exam_Id
                                            select data.Exam_Id).Distinct().ToList();
                            
                            response = (List<Get_Merge_Conflicts>)result;
                        });

            return response;
        }
    }
}
    public class Get_Merge_Conflicts
    {
        public int Exam_Id { get; set; }
        public int Merge_Question_Id { get; set; }
        public string Statement_Answer { get; set; }
    }