using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class AliasSaveRequest
    {
        public AssessmentSelection aliasAssessment { get; set; }
        public List<AssessmentSelection> assessmentList { get; set; }
    }
}