using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Assessment
{
    public class CistServiceDemographics
    {
        public int AssessmentId { get; set; }
        public string CriticalServiceName { get; set; }
        public string CriticalServiceDescription { get; set; }
        public string ItIcsName { get; set; }
        public bool MultiSite { get; set; }
        public string MultiSiteDescription { get; set; }
        public string BudgetBasis { get; set; }
        public string AuthorizedOrganizationalUserCount { get; set; }
        public string AuthorizedNonOrganizationalUserCount { get; set; }
        public string CustomersCount { get; set; }
    }
}
