//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Analysis.Analyzers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.ReportEngine.SecurityPlan
{
    public class SecurityPlanStats
    {
        int total;
        public int Total
        {
            get { return total; }
            set { total = value; }
        }

        int yes;
        public int Yes
        {
            get { return yes; }
            set { yes = value; }
        }

       
        public String Implemented
        {
            get { return StatUtils.PercentagizeAsString((double)yes,(double)total) + "%"; }
            
        }
    }
}


