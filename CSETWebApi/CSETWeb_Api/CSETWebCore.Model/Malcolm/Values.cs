using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Malcolm
{
    public class Values
    {
        public List<Buckets> Buckets { get; set; }
        public int DocCountErrorUpperBound { get; set; }
        public int SumOtherDocCount { get; set; }
    }
}
