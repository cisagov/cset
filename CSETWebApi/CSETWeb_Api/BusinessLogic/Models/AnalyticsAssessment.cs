using System;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class AnalyticsAssessment
    {
        public DateTime AssessmentCreatedDate { get; set; }
        public string AssessmentCreatorId { get; set; }
        public DateTime? LastAccessedDate { get; set; }        
        public string Alias { get; set; }
        public string Assessment_GUID { get; set; }
        public DateTime Assessment_Date { get; set; }
    }
}