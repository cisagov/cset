//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Malcolm
{
    public class Buckets
    {
        public int Doc_Count { get; set; }
        public string Key { get; set; }
        public int Distance { get; set; }
        public ValuePairs Values { get; set; }
        //public List<ValuePairs> Values { get; set; }

        //public int DocCountErrorUpperBound { get; set; }
        //public int SumOtherDocCount { get; set; }
    }
}
