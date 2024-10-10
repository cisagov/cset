//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class AnswerCounts
    {
        public int AssessmentId { get; set; }
        public string Alias { get; set; }
        public int Total { get; set; }
        public int Y { get; set; }
        public int N { get; set; }
        public int NA { get; set; }
        public int A { get; set; }
        public int U { get; set; }
    }


    public class AnswerCountsGeneric
    {
        public int AssessmentId { get; set; }
        public int ModelId { get; set; }
        public string Alias { get; set; }

        public List<AnswerCountsAndPercentages> AnswerCounts { get; set; } = new List<AnswerCountsAndPercentages>();

    }


    public class AnswerCountsAndPercentages
    {
        public string Answer_Text { get; set; }
        public int QC { get; set; }
        public int Total { get; set; }
        public int Percent { get; set; }
    }


    public class usp_getStandardSummaryOverall
    {
        public string Answer_Full_Name { get; set; }
        public string Answer_Text { get; set; }
        public int qc { get; set; }
        public int Total { get; set; }
        public int Percent { get; set; }
    }
}