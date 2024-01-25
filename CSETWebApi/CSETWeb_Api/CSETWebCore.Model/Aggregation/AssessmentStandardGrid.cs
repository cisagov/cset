//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class AssessmentStandardGrid
    {
        public Aggregation Aggregation { get; set; }
        public List<AggregAssessment> Assessments { get; set; }
    }
}