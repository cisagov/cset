using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.Analytics;

public class AggregationAssessment
{
    public ASSESSMENTS Assessment { get; set; }
    public List<ANSWER> Answers { get; set; }
    public DEMOGRAPHICS Demographics { get; set; }
    public List<DOCUMENT_FILE> Documents { get; set; }
    public List<FINDING> Findings { get; set; }
}