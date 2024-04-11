//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
