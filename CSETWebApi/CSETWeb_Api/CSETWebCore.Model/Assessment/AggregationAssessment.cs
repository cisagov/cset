using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Analytics;

namespace CSETWebCore.Model.Assessment
{
    public class AggregationAssessment
    {
        public ASSESSMENTS Assessment { get; set; }
        public List<ANSWER> Answers { get; set; }
        public AgDemographics Demographics { get; set; }
        public List<DOCUMENT_FILE> Documents { get; set; }
        public List<FINDING> Findings { get; set; }
    }
}
