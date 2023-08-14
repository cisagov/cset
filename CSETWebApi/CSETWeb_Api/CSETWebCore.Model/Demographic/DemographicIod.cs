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
        // Most important
        public string Standard1 { get; set; }
        // Second important
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
        /// This list indicates the organizations with whom we
        /// share cybersecurity-related information.
        /// ISAC, FBI, CONSULT, DHS, STATE, PEERS, NCFTA
        /// </summary>
        public List<string> ShareOrgs { get; set; } = new List<string>();
        public string ShareOther { get; set; }


        public string Barrier1 { get; set; }
        public string Barrier2 { get; set; }

        public string BusinessUnit { get; set; }



        // ================================================================
        //  Following are the collections to support dropdown lists,
        //  checkbox and radio button lists
        // ================================================================
        

        public List<ListItem2> ListOrgTypes { get; set; } = new List<ListItem2>();

        public List<ListItem2> ListSectors { get; set; } = new List<ListItem2>();

        public List<ListItem2> ListSubsectors { get; set; } = new List<ListItem2>();
        

        public List<ListItem2> ListNumberEmployeeTotal { get; set; } = new List<ListItem2>();

        public List<ListItem2> ListNumberEmployeeUnit { get; set; } = new List<ListItem2>();

        public List<ListItem2> ListRevenueAmounts { get; set; } = new List<ListItem2>();

        /// <summary>
        /// Used for question 4 
        /// </summary>
        public List<ListItem2> ListRevenuePercentages { get; set; } = new List<ListItem2>();

        /// <summary>
        /// The number of people served annually by the critical service.
        /// lUsed for question 5
        /// </summary>
        public List<ListItem2> ListNumberPeopleServed { get; set; } = new List<ListItem2>();

        /// <summary>
        /// Used for question 6
        /// </summary>
        public List<ListItem2> ListCISectors { get; set; } = new List<ListItem2>();

        /// <summary>
        /// Used for question 8
        /// </summary>
        public List<ListItem2> ListRegulationTypes { get; set; } = new List<ListItem2>();

        /// <summary>
        /// Organizations with whom you share cyber data.
        /// Used for question 9
        /// </summary>
        public List<ListItem2> ListShareOrgs { get; set; } = new List<ListItem2>();

        /// <summary>
        /// Used for question 10
        /// </summary>
        public List<ListItem2> ListBarriers { get; set; } = new List<ListItem2>();

        
    }
}
