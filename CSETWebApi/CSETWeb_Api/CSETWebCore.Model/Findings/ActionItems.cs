//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Model.Findings
{
    public class ActionItems
    {
        public int Question_Id { get; set; }
        public string Description { get; set; }
        public string Action_Items { get; set; }
        public string Regulatory_Citation { get; set; }

    }
}