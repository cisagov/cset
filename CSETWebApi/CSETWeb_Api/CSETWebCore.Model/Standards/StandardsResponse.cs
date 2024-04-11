//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Standards
{
    public class StandardsResponse
    {
        public List<StandardCategory> Categories { get; set; }
        public int QuestionCount { get; set; }
        public int RequirementCount { get; set; }
    }
}