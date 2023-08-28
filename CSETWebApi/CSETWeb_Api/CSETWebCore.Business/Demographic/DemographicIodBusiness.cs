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
            var opts = _context.DETAILS_DEMOGRAPHICS_OPTIONS.ToList();

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

            // org types
            d.ListOrgTypes = opts.Where(opt => opt.DataItemName == "ORG-TYPE").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();

            // get the subsectors for the current sector (if there is one)
            if (!string.IsNullOrEmpty(d.Sector))
            {
                d.ListSubsectors = GetSubsectors(int.Parse(d.Sector));
            }


            d.ListNumberEmployeeTotal = opts.Where(opt => opt.DataItemName == "NUM-EMP-TOTAL").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();

            d.ListNumberEmployeeUnit = opts.Where(opt => opt.DataItemName == "NUM-EMP-UNIT").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();

            d.ListRevenueAmounts = opts.Where(opt => opt.DataItemName == "ANN-REVENUE").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();

            d.ListRevenuePercentages = opts.Where(opt => opt.DataItemName == "ANN-REVENUE-PERCENT").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();


            d.ListShareOrgs = opts.Where(opt => opt.DataItemName == "SHARE-ORG").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();


            d.ListRegulationTypes = opts.Where(opt => opt.DataItemName == "REG-TYPE").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();


            d.ListBarriers = opts.Where(opt => opt.DataItemName == "BARRIER").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();

            var sectors = _context.SECTOR.Where(x => x.Is_NIPP).ToList().OrderBy(y => y.SectorName);

            d.ListSectors = new List<ListItem2>();
            foreach (var sec in sectors)
            {
                d.ListSectors.Add(new ListItem2
                {
                    OptionValue = "sec.SectorId",
                    OptionText = sec.SectorName
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

            return list.Select(x => new ListItem2() { OptionValue = "x.IndustryId", OptionText = x.IndustryName }).ToList();
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
