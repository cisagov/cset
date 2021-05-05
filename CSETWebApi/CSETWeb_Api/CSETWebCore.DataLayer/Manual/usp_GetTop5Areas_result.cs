//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.DataLayer
{
    public class usp_GetTop5Areas_result
    {
        public int Assessment_Id { get; set; }
        public string Question_Group_Heading { get; set; }
        public int YesCount { get; set; }
        public int NoCount { get; set; }
        public int NaCount { get; set; }
        public int AlternateCount { get; set; }
        public int UnansweredCount { get; set; }
        public int Total { get; set; }
        public double percentage { get; set; }        
        public string TopBottomType { get; set; }
        public double pdifference { get; set; }
        public DateTime Assessment_Date { get; set; }
    }
}