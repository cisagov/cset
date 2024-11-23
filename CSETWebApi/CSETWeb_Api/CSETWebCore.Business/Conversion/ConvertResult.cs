//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.Identity.Client;

namespace CSETWebCore.Business.Contact
{
    public class ConvertResult
    {
        public string NewName{get;set;}
        public int newAssessmentId { get; set; }
    }
}