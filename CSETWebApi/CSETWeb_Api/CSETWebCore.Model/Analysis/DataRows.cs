//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Model.Analysis
{
    public class DataRows
    {
        public string title { get; set; }
        public Decimal? rank { get; set; }
        public int? failed { get; set; }
        public int? passed { get; set; }
        public int? total { get; set; }
        public Decimal? percent { get; set; }

        // the following fields are used for component type data display
        public int? yes { get; set; }
        public int? no { get; set; }
        public int? na { get; set; }
        public int? alt { get; set; }
        public int? unanswered { get; set; }
    }
}