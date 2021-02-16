//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class AggInformation
    {
        public AggInformation()
        {
        }

        public string Assessment_Name { get; set; }
        public DateTime? Assessment_Date { get; set; }
        public string Assessor_Name { get; set; }
    }
}