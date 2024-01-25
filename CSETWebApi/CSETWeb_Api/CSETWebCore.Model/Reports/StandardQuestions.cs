//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Business.Reports
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
