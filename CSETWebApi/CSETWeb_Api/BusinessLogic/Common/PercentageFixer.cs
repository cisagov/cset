using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Common
{

    /// <summary>
    /// Rounding can lead to a percentage total of 101% or 99%.  This class
    /// repetitively steals a point from the largest slice of the pie to get to 
    /// 100% with the least impact.
    /// </summary>
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
