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
    public class CisServiceDemographics
    {
        public int AssessmentId { get; set; }
        public string CriticalServiceDescription { get; set; }

        [DisplayName("IT ICS Name")]
        public string ItIcsName { get; set; }
        public bool MultiSite { get; set; }
        public string MultiSiteDescription { get; set; }
        public string BudgetBasis { get; set; }
        public string AuthorizedOrganizationalUserCount { get; set; }
        public string AuthorizedNonOrganizationalUserCount { get; set; }
        public string CustomersCount { get; set; }

        [DisplayName("IT ICS Staff Count")]
        public string ItIcsStaffCount { get; set; }
        [DisplayName("Cybersecurity IT ICS Staff Count")]
        public string CybersecurityItIcsStaffCount { get; set; }
    }
}
