//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

namespace DataLayerCore.Model
{
    using System;
    using System.Collections.Generic;
    
    public partial class vParameter
    {
        public int Parameter_ID { get; set; }
        public string Parameter_Name { get; set; }
        public Nullable<int> Assessment_ID { get; set; }
        public string Default_Value { get; set; }
    }
}


