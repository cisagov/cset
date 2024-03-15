//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Maturity
{
    public class MaturityAssessment
    {
        public int AssessmentFactorId { get; set; }
        public string AssessmentFactor { get; set; }
        public string AssessmentFactorMaturity { get; set; }
        public int Sequence { get; set; }
        public List<MaturityComponent> Components { get; set; }
    }
}