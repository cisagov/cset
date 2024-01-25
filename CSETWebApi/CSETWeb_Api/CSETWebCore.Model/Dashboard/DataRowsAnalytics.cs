//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
namespace CSETWebCore.Model.Dashboard
{
    public class DataRowsAnalytics
    {
        public float median;

        public string title { get; set; }
        public Decimal? rank { get; set; }
        public int? failed { get; set; }
        public int? passed { get; set; }
        public int? total { get; set; }
        public Decimal? percent { get; set; }
        public int? min { get; set; }
        public int? max { get; set; }
        public double? avg { get; set; }
        public string Question_Group_Heading { get; set; }

        public double minimum { get; set; }

        public double maximum { get; set; }

        public double average { get; set; }

        // the following fields are used for component type data display
        public int? yes { get; set; }
        public int? no { get; set; }
        public int? na { get; set; }
        public int? alt { get; set; }
        public int? unanswered { get; set; }
    }
}

