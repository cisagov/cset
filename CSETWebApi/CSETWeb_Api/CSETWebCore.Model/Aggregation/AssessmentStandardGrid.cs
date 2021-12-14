using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class AssessmentStandardGrid
    {
        public Aggregation Aggregation { get; set; }
        public List<AggregAssessment> Assessments { get; set; }
    }
}