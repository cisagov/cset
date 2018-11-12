//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSET_Main.ReportEngine.Builder
{
    class AliasDescendingSorter: IComparer<RankedAlias>
    {
        public int Compare(RankedAlias x, RankedAlias y)
        {
            return Decimal.Compare(y.YesValue, x.YesValue);
        }
    }
}


