//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class AggregAssessment
    {
        public int AssessmentId { get; set; }
        public string AssessmentName { get; set; }
        public DateTime AssessmentDate { get; set; }
        public string Alias { get; set; }

        public bool useMaturity { get; set; }

        public bool useStandard { get; set; }

        public List<SelectedStandards> SelectedStandards { get; set; }

        public AggregAssessment()
        {
            this.SelectedStandards = new List<SelectedStandards>();
        }
    }
}