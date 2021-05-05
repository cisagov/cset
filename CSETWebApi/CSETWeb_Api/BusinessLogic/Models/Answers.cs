//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Manual;
using CSETWebCore.DataLayer;
using Snickler.EFCore;

namespace CSETWeb_Api.BusinessLogic.Models
{

    /// <summary>
    /// This must match the columns returned by the stored proc
    /// RelevantAnswers.  It returns a set of ANSWER records
    /// that are relative to the assessment's current SAL, standards
    /// and mode (questions or requirements).
    /// </summary>
    public class RelevantAnswers
    {
        public int Assessment_ID { get; set; }
        public int Answer_ID { get; set; }
        public bool Is_Requirement { get; set; }
        public int Question_Or_Requirement_ID { get; set; }
        public bool Mark_For_Review { get; set; }
        public string Comment { get; set; }
        public string Alternate_Justification { get; set; }
        public int Question_Number { get; set; }
        public string Answer_Text { get; set; }
        public string Component_Guid { get; set; }
        public bool Is_Component { get; set; }
        public string Custom_Question_Guid { get; set; }
        public bool Is_Framework { get; set; }
        public int Old_Answer_ID { get; set; }
        public bool Reviewed { get; set; }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        public static List<RelevantAnswers> GetAnswersForAssessment(int assessmentID)
        {
            List<RelevantAnswers> answers = new List<RelevantAnswers>();

            using (var db = new CSET_Context())
            {
                db.LoadStoredProc("[RelevantAnswers]")
                  .WithSqlParam("assessment_id", assessmentID)
                  .ExecuteStoredProc((handler) =>
                  {
                      answers = handler.ReadToList<RelevantAnswers>().Distinct().ToList();
                  });
            }

            return answers;
        }
    }
}

