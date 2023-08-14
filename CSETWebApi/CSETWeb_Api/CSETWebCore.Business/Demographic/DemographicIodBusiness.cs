using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Demographic;


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
            var shareOrgs = x.FindAll(z => z.DataItemName.StartsWith("SHARE-ORG-")).ToList();


            // share other
            d.ShareOther = x.Find(z => z.DataItemName == "SHARE-OTHER")?.StringValue;
            // barrier 1
            d.Barrier1 = x.Find(z => z.DataItemName == "BARRIER1")?.StringValue;
            // barrier 2
            d.Barrier2 = x.Find(z => z.DataItemName == "BARRIER2")?.StringValue;

            d.BusinessUnit = x.Find(z => z.DataItemName == "BUSINESS-UNIT")?.StringValue;

            // ...


            d.ListOrgTypes = new List<ListItem2> {
                new ListItem2() { Key = "1", Name = "Industry"},
                new ListItem2() { Key = "2", Name = "Federal Entity"},
                new ListItem2() { Key = "3", Name = "SLTT"}
            };

            // get the subsectors for the current sector (if there is one)
            if (!string.IsNullOrEmpty(d.Sector))
            {
                d.ListSubsectors = GetSubsectors(int.Parse(d.Sector));
            }


            d.ListNumberEmployeeTotal = new List<ListItem2>
            {
                  new ListItem2() { Key = "1", Name = "< 100"},
                  new ListItem2() { Key = "2", Name = "100-500"},
                  new ListItem2() { Key = "3", Name = "501-1,000"},
                  new ListItem2() { Key = "4", Name = "1,001-5,000"},
                  new ListItem2() { Key = "5", Name = "5,001-10,000"},
                  new ListItem2() { Key = "6", Name = "10,001-50,000"},
                  new ListItem2() { Key = "7", Name = "50,001-100,000"},
                  new ListItem2() { Key = "8", Name = "> 100,000"}
            };

            d.ListNumberEmployeeUnit = new List<ListItem2>
            {
                  new ListItem2() { Key = "1", Name = "N/A"},
                  new ListItem2() { Key = "2", Name = "< 50"},
                  new ListItem2() { Key = "3", Name = "50-100"},
                  new ListItem2() { Key = "4", Name = "101-250"},
                  new ListItem2() { Key = "5", Name = "251-500"},
                  new ListItem2() { Key = "6", Name = "501-1,000"},
                  new ListItem2() { Key = "7", Name = "1,001-2,500"},
                  new ListItem2() { Key = "8", Name = "2,501-5,000"},
                  new ListItem2() { Key = "9", Name = "5,001-10,000"},
                  new ListItem2() { Key = "10", Name = "> 10,000"}
            };

            d.ListRevenueAmounts = new List<ListItem2>
            {
                  new ListItem2() { Key = "1", Name = "< $100,000"},
                  new ListItem2() { Key = "2", Name = "$100,000 - $500,000"},
                  new ListItem2() { Key = "3", Name = "$500,000 - $1 million"},
                  new ListItem2() { Key = "4", Name = "$1M - $10M"},
                  new ListItem2() { Key = "5", Name = "$10M - $100M"},
                  new ListItem2() { Key = "6", Name = "$100M - $500M"},
                  new ListItem2() { Key = "7", Name = "$500M - $1B"},
                  new ListItem2() { Key = "8", Name = "> $1B"}
            };

            d.ListRevenuePercentages = new List<ListItem2>
            {
                  new ListItem2() { Key = "1", Name = "1-10%"},
                  new ListItem2() { Key = "2", Name = "11-20%"},
                  new ListItem2() { Key = "3", Name = "21-30%"},
                  new ListItem2() { Key = "4", Name = "31-40%"},
                  new ListItem2() { Key = "5", Name = "41-50%"},
                  new ListItem2() { Key = "6", Name = "51-60%"},
                  new ListItem2() { Key = "7", Name = "61-70%"},
                  new ListItem2() { Key = "8", Name = "71-80%"},
                  new ListItem2() { Key = "9", Name = "81-90%"},
                  new ListItem2() { Key = "10", Name = "91-100%"}
            };


            d.ListShareOrgs = new List<ListItem2>
            {
                new ListItem2() { Key = "1", Name = "ISAC and/ or Coordinating Council" },
                new ListItem2() { Key = "2", Name = "FBI - InfraGard" },
                new ListItem2() { Key = "3", Name = "Cybersecurity suppliers/ consultants" },
                new ListItem2() { Key = "4", Name = "Department of Homeland Security" },
                new ListItem2() { Key = "5", Name = "State or local government group" },
                new ListItem2() { Key = "6", Name = "Industry peers(informal exchanges)" },
                new ListItem2() { Key = "7", Name = "NCFTA" }
            };


            d.ListRegulationTypes = new List<ListItem2>
            {
                new ListItem2() { Key = "1", Name = "Federal regulation, not industry specific (HIPAA, FTC, DFARS)" },
                new ListItem2() { Key = "2", Name = "Federal regulation, industry specific (NERC-CIP)" },
                new ListItem2() { Key = "3", Name = "Federal civilian agency oversight (FISMA)" },
                new ListItem2() { Key = "4", Name = "State regulation, not industry specific (breach notification)" },
                new ListItem2() { Key = "5", Name = "State regulation, industry specific" },
                new ListItem2() { Key = "6", Name = "State civilian agency oversight" }
            };


            d.ListBarriers = new List<ListItem2>
            {
                new ListItem2() { Key = "1", Name = "Potential for increased regulatory scrutiny" },
                new ListItem2() { Key = "2", Name = "Potential for legal action" },
                new ListItem2() { Key = "3", Name = "Anti - trust regulation" },
                new ListItem2() { Key = "4", Name = "Privacy regulation" },
                new ListItem2() { Key = "5", Name = "Confidentiality of company information" },
                new ListItem2() { Key = "6", Name = "Impact on reputation" },
                new ListItem2() { Key = "7", Name = "Relevancy of the information available" }
            };

            var sectors = _context.SECTOR.Where(x => x.Is_NIPP).ToList().OrderBy(y => y.SectorName);

            d.ListSectors = new List<ListItem2>();
            foreach (var sec in sectors)
            {
                d.ListSectors.Add(new ListItem2
                {
                    Key = "sec.SectorId",
                    Name = sec.SectorName
                });
            }

            return d;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<ListItem2> GetSubsectors(int sectorId)
        {
            var list = _context.SECTOR_INDUSTRY.Where(x => x.SectorId == sectorId)
               .OrderBy(a => a.IndustryName).ToList();

            var otherItems = list.Where(x => x.Is_Other).ToList();
            foreach (var o in otherItems)
            {
                list.Remove(o);
                list.Add(o);
            }

            return list.Select(x => new ListItem2() { Key = "x.IndustryId", Name = x.IndustryName }).ToList();
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
