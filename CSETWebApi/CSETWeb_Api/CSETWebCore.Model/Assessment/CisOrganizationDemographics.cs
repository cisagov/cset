//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Assessment
{
    public class CisOrganizationDemographics
    {
        public int AssessmentId { get; set; }
        public bool MotivationCrr { get; set; }
        public string MotivationCrrDescription { get; set; }
        public bool MotivationRrap { get; set; }
        public string MotivationRrapDescription { get; set; }
        public bool MotivationOrganizationRequest { get; set; }
        public string MotivationOrganizationRequestDescription { get; set; }
        public bool MotivationLawEnforcementRequest { get; set; }
        public string MotivationLawEnforcementRequestDescription { get; set; }
        public bool MotivationDirectThreats { get; set; }
        public string MotivationDirectThreatsDescription { get; set; }
        public bool MotivationSpecialEvent { get; set; }
        public string MotivationSpecialEventDescription { get; set; }
        public bool MotivationOther { get; set; }
        public string MotivationOtherDescription { get; set; }
        public string ParentOrganization { get; set; }
        public string OrganizationName { get; set; }
        public string SiteName { get; set; }
        public string StreetAddress { get; set; }
        public DateTime? VisitDate { get; set; }
        public bool CompletedForSltt { get; set; }
        public bool CompletedForFederal { get; set; }
        public bool CompletedForNationalSpecialEvent { get; set; }
        public string CikrSector { get; set; }
        public string SubSector { get; set; }

        public string CustomersCount { get; set; }

        [DisplayName("IT ICS Staff Count")]
        public string ItIcsStaffCount { get; set; }
        [DisplayName("Cybersecurity IT ICS Staff Count")]
        public string CybersecurityItIcsStaffCount { get; set; }
    }
}
