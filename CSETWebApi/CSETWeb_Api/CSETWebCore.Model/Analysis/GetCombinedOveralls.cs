//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Analysis
{
    public class GetCombinedOveralls
    {
        public string StatType { get; set; }
        public int? Total { get; set; }
        public int? Y { get; set; }
        public int? N { get; set; }
        public int? NA { get; set; }
        public int? A { get; set; }
        public int? U { get; set; }
        public int? YCount { get; set; }
        public int? NCount { get; set; }
        public int? NACount { get; set; }
        public int? ACount { get; set; }
        public int? UCount { get; set; }
        public double Value { get; set; }
        public int? TotalNoNA { get; set; }
    }
}