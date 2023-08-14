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
        private CSETContext _context;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public DemographicIodBusiness(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Returns an object 
        /// </summary>
        /// <returns></returns>
        public DemographicIod GetDemographics(int assessmentId)
        {
            var x = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).ToList();

            var d = new DemographicIod();
            d.AssessmentId = assessmentId;

            d.OrganizationType = x.Find(z => z.DataItemName == "ORG-TYPE")?.StringValue;
            d.OrganizationName = x.Find(z => z.DataItemName == "ORG-NAME")?.StringValue;
            d.Sector = x.Find(z => z.DataItemName == "SECTOR")?.StringValue;
            d.Subsector = x.Find(z => z.DataItemName == "SUBSECTOR")?.StringValue;
            d.NumberEmployeesTotal = x.Find(z => z.DataItemName == "NUM-EMP-TOTAL")?.StringValue;
            d.NumberEmployeesUnit = x.Find(z => z.DataItemName == "NUM-EMP-UNIT")?.StringValue;

            d.AnnualRevenue = x.Find(z => z.DataItemName == "ANN-REVENUE")?.StringValue;

            // body of practice / standard
            d.UsesStandard = bool.Parse(x.Find(z => z.DataItemName == "STANDARD-USED")?.StringValue ?? "false");
            // most important
            d.Standard1 = x.Find(z => z.DataItemName == "STANDARD1")?.StringValue;
            // second most important
            d.Standard2 = x.Find(z => z.DataItemName == "STANDARD2")?.StringValue;
            // must comply?
            d.RequiredToComply = bool.Parse(x.Find(z => z.DataItemName == "REGULATION-REQD")?.StringValue ?? "false");
            // reg type 1
            d.RegulationType1 = x.Find(z => z.DataItemName == "REG-TYPE1")?.StringValue;
            // regulation 1 (free form)
            d.Reg1Other = x.Find(z => z.DataItemName == "REG-1-OTHER")?.StringValue;
            // reg type 2
            d.RegulationType2 = x.Find(z => z.DataItemName == "REG-TYPE2")?.StringValue;
            // regulation 2 (free forma0
            d.Reg2Other = x.Find(z => z.DataItemName == "REG-2-OTHER")?.StringValue;
            // share orgs (multiples - how best to handle nicely?)
            // ??????
            // share other
            d.ShareOther = x.Find(z => z.DataItemName == "SHARE-OTHER")?.StringValue;
            // barrier 1
            d.Barrier1 = x.Find(z => z.DataItemName == "BARRIER1")?.StringValue;
            // barrier 2
            d.Barrier2 = x.Find(z => z.DataItemName == "BARRIER2")?.StringValue;

            d.BusinessUnit = x.Find(z => z.DataItemName == "BUSINESS-UNIT")?.StringValue;

            // ...


            d.ListOrgTypes = new List<ListItem> {
                new ListItem() { Id = 1, Value = "Industry"},
                new ListItem() { Id = 2, Value = "Federal Entity"},
                new ListItem() { Id = 3, Value = "SLTT"}
            };

            // get the subsectors for the current sector (if there is one)
            if (!string.IsNullOrEmpty(d.Sector))
            {
                d.ListSubsectors = GetSubsectors(int.Parse(d.Sector));
            }


            d.ListNumberEmployeeTotal = new List<ListItem>
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

            d.ListNumberEmployeeUnit = new List<ListItem>
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

            d.ListRevenueAmounts = new List<ListItem>
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

            d.ListRevenuePercentages = new List<ListItem>
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


            d.ListShareOrgs = new List<ListItem>
            {
                new ListItem() { Id = 1, Value = "ISAC and/ or Coordinating Council" },
                new ListItem() { Id = 2, Value = "FBI - InfraGard" },
                new ListItem() { Id = 3, Value = "Cybersecurity suppliers/ consultants" },
                new ListItem() { Id = 4, Value = "Department of Homeland Security" },
                new ListItem() { Id = 5, Value = "State or local government group" },
                new ListItem() { Id = 6, Value = "Industry peers(informal exchanges)" },
                new ListItem() { Id = 7, Value = "NCFTA" }
            };


            d.ListRegulationTypes = new List<ListItem>
            {
                new ListItem() { Id = 1, Value = "Federal regulation, not industry specific (HIPAA, FTC, DFARS)" },
                new ListItem() { Id = 2, Value = "Federal regulation, industry specific (NERC-CIP)" },
                new ListItem() { Id = 3, Value = "Federal civilian agency oversight (FISMA)" },
                new ListItem() { Id = 4, Value = "State regulation, not industry specific (breach notification)" },
                new ListItem() { Id = 5, Value = "State regulation, industry specific" },
                new ListItem() { Id = 6, Value = "State civilian agency oversight" }
            };


            var sectors = _context.SECTOR.Where(x => x.Is_NIPP).ToList().OrderBy(y => y.SectorName);

            d.ListSectors = new List<ListItem>();
            foreach (var sec in sectors)
            {
                d.ListSectors.Add(new ListItem
                {
                    Id = sec.SectorId,
                    Value = sec.SectorName
                });
            }

            return d;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<ListItem> GetSubsectors(int sectorId)
        {
            var list = _context.SECTOR_INDUSTRY.Where(x => x.SectorId == sectorId)
               .OrderBy(a => a.IndustryName).ToList();

            var otherItems = list.Where(x => x.Is_Other).ToList();
            foreach (var o in otherItems)
            {
                list.Remove(o);
                list.Add(o);
            }

            return list.Select(x => new ListItem() { Id = x.IndustryId, Value = x.IndustryName }).ToList();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="demographic"></param>
        public void SaveDemographics(DemographicIod demographic)
        {
            //  Clean out any existing detail records
            var oldRecords = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == demographic.AssessmentId).ToList();
            _context.DETAILS_DEMOGRAPHICS.RemoveRange(oldRecords);
            _context.SaveChanges();

            SaveDemoRecord(demographic.AssessmentId, "ORG-TYPE", demographic.OrganizationType);
            SaveDemoRecord(demographic.AssessmentId, "ORG-NAME", demographic.OrganizationName);
            SaveDemoRecord(demographic.AssessmentId, "SECTOR", demographic.Sector);
            SaveDemoRecord(demographic.AssessmentId, "SUBSECTOR", demographic.Subsector);
            SaveDemoRecord(demographic.AssessmentId, "NUM-EMP-TOTAL", demographic.NumberEmployeesTotal);
            SaveDemoRecord(demographic.AssessmentId, "NUM-EMP-UNIT", demographic.NumberEmployeesUnit);
            SaveDemoRecord(demographic.AssessmentId, "ANN-REVENUE", demographic.AnnualRevenue);



            SaveDemoRecord(demographic.AssessmentId, "STANDARD-USED", demographic.UsesStandard.ToString());
            SaveDemoRecord(demographic.AssessmentId, "STANDARD1", demographic.Standard1);
            SaveDemoRecord(demographic.AssessmentId, "STANDARD2", demographic.Standard2);
            SaveDemoRecord(demographic.AssessmentId, "REGULATION-REQD", demographic.RequiredToComply.ToString());
            SaveDemoRecord(demographic.AssessmentId, "REG-TYPE1", demographic.RegulationType1);
            SaveDemoRecord(demographic.AssessmentId, "REG-1-OTHER", demographic.Reg1Other);
            SaveDemoRecord(demographic.AssessmentId, "REG-TYPE2", demographic.RegulationType2);
            SaveDemoRecord(demographic.AssessmentId, "REG-2-OTHER", demographic.Reg2Other);

            SaveDemoRecord(demographic.AssessmentId, "SHARE-OTHER", demographic.ShareOther);
            SaveDemoRecord(demographic.AssessmentId, "BARRIER1", demographic.Barrier1);
            SaveDemoRecord(demographic.AssessmentId, "BARRIER2", demographic.Barrier2);

            SaveDemoRecord(demographic.AssessmentId, "BUSINESS-UNIT", demographic.BusinessUnit);



            _context.SaveChanges();
        }


        private void SaveDemoRecord(int assessmentId, string recName, string value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                StringValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }
    }
}
