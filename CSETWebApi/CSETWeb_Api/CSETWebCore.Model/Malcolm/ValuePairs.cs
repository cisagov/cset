using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Malcolm
{
    public class ValuePairs
    {
        public int Doc_Count_Error_Upper_Bound { get; set; }
        public int Sum_Other_Doc_Count { get; set; }
        public List<Buckets> Buckets { get; set; } = new List<Buckets>();
    }
}
