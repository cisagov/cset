//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class QuestionListResponse
    {
        public string SetFullName;
        public string SetShortName;
        public string SetDescription;
        public List<QuestionListCategory> Categories = new List<QuestionListCategory>();
    }
}