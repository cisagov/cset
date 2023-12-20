//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
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
        public int DocNumber { get; set; }
        public string Key { get; set; }
        public List<ValuePairs> Values { get; set; }
        //public int DocCountErrorUpperBound { get; set; }
        //public int SumOtherDocCount { get; set; }
    }
}
