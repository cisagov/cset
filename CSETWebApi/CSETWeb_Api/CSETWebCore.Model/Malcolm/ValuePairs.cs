////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System.Collections.Generic;

namespace CSETWebCore.Model.Malcolm
{
    public class ValuePairs
    {
        public int Doc_Count_Error_Upper_Bound { get; set; }
        public int Sum_Other_Doc_Count { get; set; }
        public List<Buckets> Buckets { get; set; } = new List<Buckets>();
    }
}
