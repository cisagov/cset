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

namespace CSETWeb_Api.BusinessLogic.Models
{
    /// <summary>
    /// A helper class for reporting questions containing feedback.
    /// </summary>
    public class FeedbackQuestion
    {
        public string QuestionText { get; set; }
        public int QuestionID { get; set; }
        public int AnswerID { get; set; }
        public string Feedback { get; set; }
        public string Mode { get; set; }
    }
}
