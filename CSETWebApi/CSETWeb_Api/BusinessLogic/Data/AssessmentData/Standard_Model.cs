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

namespace CSET_Main.Aggregation.Data
{
    public class Standard_Model
    {
        public bool Cnssi_1253 { get; set; }
        public bool DOD { get; set; }
        public bool Nerc5 { get; set; }

        public string Availability_Level { get; set; }

        public string Confidence_Level { get; set; }

        public string DOD_Confidentiality_Level { get; set; }

        public string DOD_MAC_Level { get; set; }

        public string Integrity_Level { get; set; }
    }
}


