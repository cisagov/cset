using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Contact
{
    public class CistPocDetail
    {
        public int ContactId { get; set; }
        public int Assessmentid { get; set; }
        public bool IsPrimaryPoc { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Title { get; set; }
        public string SiteName { get; set; }
        public string OrganizationName { get; set; }
        public string Email { get; set; }
        public string OfficePhone { get; set; }
        public string CellPhone { get; set; }
        public string ReportsTo { get; set; }
        public string EmergencyCommunicationsProtocol { get; set; }
        public bool IsSiteParticicpant { get; set; }
    }
}
