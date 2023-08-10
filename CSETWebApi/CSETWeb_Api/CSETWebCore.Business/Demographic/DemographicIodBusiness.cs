using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Demographic;
using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Drawing;

namespace CSETWebCore.Business.Demographic
{
    public class DemographicIodBusiness
    {
        /// <summary>
        /// Returns an object 
        /// </summary>
        /// <returns></returns>
        public DemographicIod GetDemographics(int assessmentId, CSETContext context)
        {
            var x = context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).ToList();

            var d = new DemographicIod();
            d.AssessmentId = assessmentId;
            d.AnnualRevenue = x.Find(z => z.DataItemName == "")?.StringValue;
            d.CriticalServiceRevenuePercent = x.Find(z => z.DataItemName == "")?.StringValue;
            // ...


            d.ListOrgTypes = new List<ListItem> { 
                new ListItem() { Id = 1, Value = "Industry"},
                new ListItem() { Id = 2, Value = "Federal Entity"},
                new ListItem() { Id = 3, Value = "SLTT"}
            };

            d.NumberEmployeeRangeTotal = new List<ListItem>
            {
                  new ListItem() { Id = 1, Value = "< 100"},
                  new ListItem() { Id = 2, Value = "100-500"},
                  new ListItem() { Id = 3, Value = "501-1,000"},
                  new ListItem() { Id = 4, Value = "1,001-5,000"},
                  new ListItem() { Id = 5, Value = "5,001-10,000"},
                  new ListItem() { Id = 6, Value = "10,001-50,000"},
                  new ListItem() { Id = 7, Value = "50,001-100,000"},
                  new ListItem() { Id = 8, Value = "> 100,000"}
            };

            d.NumberEmployeeRangeUnit = new List<ListItem>
            {
                  new ListItem() { Id = 1, Value = "N/A"},
                  new ListItem() { Id = 2, Value = "< 50"},
                  new ListItem() { Id = 3, Value = "50-100"},
                  new ListItem() { Id = 4, Value = "101-250"},
                  new ListItem() { Id = 5, Value = "251-500"},
                  new ListItem() { Id = 6, Value = "501-1,000"},
                  new ListItem() { Id = 7, Value = "1,001-2,500"},
                  new ListItem() { Id = 8, Value = "2,501-5,000"},
                  new ListItem() { Id = 9, Value = "5,001-10,000"},
                  new ListItem() { Id = 10, Value = "> 10,000"}
            };

            d.RevenueAmounts = new List<ListItem>
            {
                  new ListItem() { Id = 1, Value = "< $100,000"},
                  new ListItem() { Id = 2, Value = "$100,000 - $500,000"},
                  new ListItem() { Id = 3, Value = "$500,000 - $1 million"},
                  new ListItem() { Id = 4, Value = "$1M - $10M"},
                  new ListItem() { Id = 5, Value = "$10M - $100M"},
                  new ListItem() { Id = 6, Value = "$100M - $500M"},
                  new ListItem() { Id = 7, Value = "$500M - $1B"},
                  new ListItem() { Id = 8, Value = "> $1B"}
            };

            d.RevenuePercentages = new List<ListItem>
            {
                  new ListItem() { Id = 1, Value = "1-10%"},
                  new ListItem() { Id = 2, Value = "11-20%"},
                  new ListItem() { Id = 3, Value = "21-30%"},
                  new ListItem() { Id = 4, Value = "31-40%"},
                  new ListItem() { Id = 5, Value = "41-50%"},
                  new ListItem() { Id = 6, Value = "51-60%"},
                  new ListItem() { Id = 7, Value = "61-70%"},
                  new ListItem() { Id = 8, Value = "71-80%"},
                  new ListItem() { Id = 9, Value = "81-90%"},
                  new ListItem() { Id = 10, Value = "91-100%"}
            };


            d.ShareOrgs = new List<ListItem>
            {
                new ListItem() { Id = 1, Value = "ISAC and/ or Coordinating Council" },
                new ListItem() { Id = 2, Value = "FBI - InfraGard" },
                new ListItem() { Id = 3, Value = "Cybersecurity suppliers/ consultants" },
                new ListItem() { Id = 4, Value = "Department of Homeland Security" },
                new ListItem() { Id = 5, Value = "State or local government group" },
                new ListItem() { Id = 6, Value = "Industry peers(informal exchanges)" },
                new ListItem() { Id = 7, Value = "NCFTA" }
            };


            d.RegulationTypes = new List<ListItem>
            {
                new ListItem() { Id = 1, Value = "Federal regulation, not industry specific (HIPAA, FTC, DFARS)" },
                new ListItem() { Id = 2, Value = "Federal regulation, industry specific (NERC-CIP)" },
                new ListItem() { Id = 3, Value = "Federal civilian agency oversight (FISMA)" },
                new ListItem() { Id = 4, Value = "State regulation, not industry specific (breach notification)" },
                new ListItem() { Id = 5, Value = "State regulation, industry specific" },
                new ListItem() { Id = 6, Value = "State civilian agency oversight" }
            };


            return d;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="demographic"></param>
        public void SaveDemographics(DemographicIod demographic)
        {

        }
    }
}
