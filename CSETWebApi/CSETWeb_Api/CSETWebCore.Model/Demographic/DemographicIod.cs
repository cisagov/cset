using CSETWebCore.DataLayer.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace CSETWebCore.Model.Demographic
{
    /// <summary>
    /// The demographic data collected by IOD CSAs.  
    /// </summary>
    public class DemographicIod
    {
        public int AssessmentId { get; set; }

        public string OrganizationType { get; set; }
        public string OrganizationName { get; set; }

        public string Sector { get; set; }
        public string Subsector { get; set; }
        
        public string NumberEmployeesTotal { get; set; }
        public string NumberEmployeesUnit { get; set; }


        public string AnnualRevenue { get; set; }
        public string CriticalServiceRevenuePercent { get; set; }

        public string NumberPeopleServedByCritSvc { get; set; }

        public string DisruptedSector1 { get; set; }
        public string DisruptedSector2 { get; set; }


        /// <summary>
        /// Does your organization use a body of practice, industry
        /// standard, or similar resource to support or inform its
        /// cybersecurity efforts?
        /// </summary>
        public bool UsesStandard { get; set; }
        public string Standard1 { get; set; }
        public string Standard2 { get; set; }


        /// <summary>
        /// Is your organization required to comply with mandatory,
        /// cybersecurity-related regulation?
        /// </summary>
        public bool RequiredToComply { get; set; }
        public string RegulationType1 { get; set; }
        public string Reg1Other { get; set; }
        public string RegulationType2 { get; set; }
        public string Reg2Other { get; set; }


        /// <summary>
        /// The following fields indicate with whom the organization
        /// shares with or obtains cybersecurity-related information from.
        /// </summary>
        public bool ShareISAC { get; set; }
        public bool ShareFBI { get; set; }
        public bool ShareCyberConsultants { get; set; }
        public bool ShareDHS { get; set; }
        public bool ShareLocalGovt { get; set; }
        public bool ShareNCFTA { get; set; }
        public string ShareOther { get; set; }


        public string Barrier1 { get; set; }
        public string Barrier2 { get; set; }

        public string BusinessUnit { get; set; }



        // ================================================================
        //  Following are the collections to support dropdown lists,
        //  checkbox and radio button lists
        // ================================================================
        

        public List<ListItem> ListOrgTypes { get; set; } = new List<ListItem>();

        public List<ListItem> ListSectors { get; set; } = new List<ListItem>();

        public List<ListItem> ListSubsectors { get; set; } = new List<ListItem>();
        

        public List<ListItem> ListNumberEmployeeTotal { get; set; } = new List<ListItem>();

        public List<ListItem> ListNumberEmployeeUnit { get; set; } = new List<ListItem>();

        public List<ListItem> ListRevenueAmounts { get; set; } = new List<ListItem>();

        /// <summary>
        /// Used for question 4 
        /// </summary>
        public List<ListItem> ListRevenuePercentages { get; set; } = new List<ListItem>();

        /// <summary>
        /// The number of people served annually by the critical service.
        /// lUsed for question 5
        /// </summary>
        public List<ListItem> ListNumberPeopleServed { get; set; } = new List<ListItem>();

        /// <summary>
        /// Used for question 6
        /// </summary>
        public List<ListItem> ListCISectors { get; set; } = new List<ListItem>();

        /// <summary>
        /// Used for question 8
        /// </summary>
        public List<ListItem> ListRegulationTypes { get; set; } = new List<ListItem>();

        /// <summary>
        /// Organizations with whom you share cyber data.
        /// Used for question 9
        /// </summary>
        public List<ListItem> ListShareOrgs { get; set; } = new List<ListItem>();
    }
}
