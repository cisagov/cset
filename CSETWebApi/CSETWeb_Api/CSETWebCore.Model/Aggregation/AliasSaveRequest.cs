//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class AliasSaveRequest
    {
        public AssessmentSelection aliasAssessment { get; set; }
        public List<AssessmentSelection> assessmentList { get; set; }
    }
}