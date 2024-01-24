//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Model.Assessment
{
    public class AnalyticsAssessment
    {
        public DateTime AssessmentCreatedDate { get; set; }
        public string AssessmentCreatorId { get; set; }
        public DateTime? LastModifiedDate { get; set; }
        public string Alias { get; set; }
        public string Assessment_GUID { get; set; }
        public DateTime Assessment_Date { get; set; }
        public int SectorId { get; set; }
        public int IndustryId { get; set; }
        public string Assets { get; set; }
        public string Size { get; set; }
        public string Mode { get; set; }
    }
}
