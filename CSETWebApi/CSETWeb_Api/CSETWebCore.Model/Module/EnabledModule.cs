//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Model.Module
{
    public class EnabledModule
    {
        public String ShortName { get; set; }
        public String FullName { get; set; }
        public bool Unlocked { get; set; }
    }
}