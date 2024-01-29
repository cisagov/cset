//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Helpers
{
    public class PercentageFixer
    {
        List<int?> l = new List<int?>();

        public PercentageFixer(int? y, int? n, int? na, int? a, int? u)
        {
            l.Add(y);
            l.Add(n);
            l.Add(na);
            l.Add(a);
            l.Add(u);

            while (l.Sum() > 100)
            {
                var m = l.FindIndex(x => x == l.Max());
                l[m]--;
            }
            while (l.Sum() < 100)
            {
                var m = l.FindIndex(x => x == l.Max());
                l[m]++;
            }
        }

        public int? Y { get { return l[0]; } }
        public int? N { get { return l[1]; } }
        public int? NA { get { return l[2]; } }
        public int? A { get { return l[3]; } }
        public int? U { get { return l[4]; } }
    }
}