//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class StandardQuestions
    {
        public string StandardShortName { get; set; }
        public List<SimpleStandardQuestions> Questions { get; set; }
        public StandardQuestions()
        {
            this.Questions = new List<SimpleStandardQuestions>();
        }
    }
}

