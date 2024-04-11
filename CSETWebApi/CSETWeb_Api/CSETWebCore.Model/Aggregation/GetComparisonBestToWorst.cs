//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Aggregation
{
    public class GetComparisonBestToWorst
    {
        public int Assessment_Id { get; set; }

        /// <summary>
        /// Alias?
        /// </summary>
        public string AssessmentName { get; set; }

        /// <summary>
        /// Category name
        /// </summary>
        public string Name { get; set; }

        public int AlternateCount { get; set; }
        public double AlternateValue { get; set; }

        public int NaCount { get; set; }
        public double NaValue { get; set; }

        public int NoCount { get; set; }
        public double NoValue { get; set; }

        public int TotalCount { get; set; }
        public double TotalValue { get; set; }

        public int UnansweredCount { get; set; }
        public double UnansweredValue { get; set; }

        public int YesCount { get; set; }
        public double YesValue { get; set; }


        public double Value { get; set; }
    }
}