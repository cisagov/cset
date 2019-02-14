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
    using System.ComponentModel.DataAnnotations;

    public partial class vParameter
    {
        [Key]
        public int Parameter_ID { get; set; }
        public string Parameter_Name { get; set; }
        [Key]
        public Nullable<int> Assessment_ID { get; set; }
        public string Default_Value { get; set; }
    }
}


