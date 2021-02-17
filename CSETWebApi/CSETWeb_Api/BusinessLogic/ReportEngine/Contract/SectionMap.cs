//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSET_Main.ReportEngine.Contract
{
    public class SectionMap
    {
        public int ReportSectionId { get; set; }
        public string StandardEntityName { get; set; }
        public int ReportSectionOrder { get; set; }
        public bool IsChecked { get; set; }

    }
}


