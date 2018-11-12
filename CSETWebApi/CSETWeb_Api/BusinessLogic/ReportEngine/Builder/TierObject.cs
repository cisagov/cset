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
using System.Threading.Tasks;

namespace CSET_Main.ReportEngine.Builder
{
    class TierObject
    {
        public string Tier { get; set; }
        public string TierDescription { get; set; }

        public string TableName { get; set; }

        public string TierType { get; set; }

        public int TierOrder { get; set; }
    }
}


