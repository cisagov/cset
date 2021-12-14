using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class AssessmentListResponse
    {
        public Aggregation Aggregation { get; set; }
        public List<AggregAssessment> Assessments { get; set; }

        public AssessmentListResponse()
        {
            this.Aggregation = new Aggregation();
            this.Assessments = new List<AggregAssessment>();
        }
    }
}