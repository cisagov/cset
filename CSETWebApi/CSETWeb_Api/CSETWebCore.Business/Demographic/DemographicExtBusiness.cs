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
    public class DemographicExtBusiness
    {
        private CSETContext _context;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public DemographicExtBusiness(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Returns an object containing the extended Demographics values.
        /// </summary>
        /// <returns></returns>
        public DemographicExt GetDemographics(int assessmentId)
        {
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            var info = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();

            var x = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).ToList();
            var opts = _context.DETAILS_DEMOGRAPHICS_OPTIONS.ToList();

            var d = new DemographicExt();
            d.AssessmentId = assessmentId;
            d.AssessmentDate = assessment.Assessment_Date;

            d.OrganizationType = x.Find(z => z.DataItemName == "ORG-TYPE")?.IntValue;
            d.OrganizationName = info.Facility_Name;
            d.Sector = x.Find(z => z.DataItemName == "SECTOR")?.IntValue;
            d.Subsector = x.Find(z => z.DataItemName == "SUBSECTOR")?.IntValue;
            d.NumberEmployeesTotal = x.Find(z => z.DataItemName == "NUM-EMP-TOTAL")?.IntValue;
            d.NumberEmployeesUnit = x.Find(z => z.DataItemName == "NUM-EMP-UNIT")?.IntValue;

            d.AnnualRevenue = x.Find(z => z.DataItemName == "ANN-REVENUE")?.IntValue;
            d.CriticalServiceRevenuePercent = x.Find(z => z.DataItemName == "ANN-REVENUE-PERCENT")?.IntValue;
            d.NumberPeopleServedByCritSvc = x.Find(z => z.DataItemName == "NUM-PEOPLE-SERVED")?.IntValue;

            d.CriticalDependencyIncidentResponseSupport = x.Find(z => z.DataItemName == "CRIT-DEPEND-INCIDENT-RESPONSE")?.StringValue;

            d.DisruptedSector1 = x.Find(z => z.DataItemName == "DISRUPTED-SECTOR1")?.IntValue;
            d.DisruptedSector2 = x.Find(z => z.DataItemName == "DISRUPTED-SECTOR2")?.IntValue;

            // body of practice / standard
            d.UsesStandard = x.Find(z => z.DataItemName == "STANDARD-USED")?.BoolValue ?? true;
            // most important
            d.Standard1 = x.Find(z => z.DataItemName == "STANDARD1")?.StringValue;
            // second most important
            d.Standard2 = x.Find(z => z.DataItemName == "STANDARD2")?.StringValue;
            // must comply?
            d.RequiredToComply = x.Find(z => z.DataItemName == "REGULATION-REQD")?.BoolValue ?? true;
            // reg type 1
            d.RegulationType1 = x.Find(z => z.DataItemName == "REG-TYPE1")?.IntValue;
            // regulation 1 (free form)
            d.Reg1Other = x.Find(z => z.DataItemName == "REG-1-OTHER")?.StringValue;
            // reg type 2
            d.RegulationType2 = x.Find(z => z.DataItemName == "REG-TYPE2")?.IntValue;
            // regulation 2 (free forma0
            d.Reg2Other = x.Find(z => z.DataItemName == "REG-2-OTHER")?.StringValue;
            // share orgs
            List<int> shareOrgs = x.FindAll(z => z.DataItemName.StartsWith("SHARE-ORG-")).Select(org => (int)org.IntValue).ToList();
            d.ShareOrgs = shareOrgs;

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
            if (d.Sector != null)
            {
                d.ListSubsectors = GetSubsectors((int)d.Sector);
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

            d.ListNumberPeopleServed = opts.Where(opt => opt.DataItemName == "NUM-PEOPLE-SERVED").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();

            d.ListShareOrgs = opts.Where(opt => opt.DataItemName.StartsWith("SHARE-ORG-")).Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();

            d.ListStandards = opts.Where(opt => opt.DataItemName == ("STANDARD")).Select(opts => new ListItem2()
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
                    OptionValue = sec.SectorId,
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

            return list.Select(x => new ListItem2() { OptionValue = x.IndustryId, OptionText = x.IndustryName }).ToList();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="demographic"></param>
        public void SaveDemographics(DemographicExt demographic)
        {
            var info = _context.INFORMATION.Where(x => x.Id == demographic.AssessmentId).FirstOrDefault();
            info.Facility_Name = demographic.OrganizationName;


            //  Clean out any existing detail records for demographics

            // list data items that we do not want to delete
            var nonDemographics = new List<string>() { "OTHER-REMARKS" };
            var oldRecords = _context.DETAILS_DEMOGRAPHICS
                .Where(x => x.Assessment_Id == demographic.AssessmentId && !nonDemographics.Contains(x.DataItemName))
                .ToList();
            _context.DETAILS_DEMOGRAPHICS.RemoveRange(oldRecords);
            _context.SaveChanges();


            SaveDemoRecord(demographic.AssessmentId, "ORG-TYPE", demographic.OrganizationType);
            SaveDemoRecord(demographic.AssessmentId, "SECTOR", demographic.Sector);
            SaveDemoRecord(demographic.AssessmentId, "SUBSECTOR", demographic.Subsector);
            SaveDemoRecord(demographic.AssessmentId, "NUM-EMP-TOTAL", demographic.NumberEmployeesTotal);
            SaveDemoRecord(demographic.AssessmentId, "NUM-EMP-UNIT", demographic.NumberEmployeesUnit);
            SaveDemoRecord(demographic.AssessmentId, "ANN-REVENUE", demographic.AnnualRevenue);
            SaveDemoRecord(demographic.AssessmentId, "ANN-REVENUE-PERCENT", demographic.CriticalServiceRevenuePercent);
            SaveDemoRecord(demographic.AssessmentId, "NUM-PEOPLE-SERVED", demographic.NumberPeopleServedByCritSvc);
            SaveDemoRecord(demographic.AssessmentId, "DISRUPTED-SECTOR1", demographic.DisruptedSector1);
            SaveDemoRecord(demographic.AssessmentId, "DISRUPTED-SECTOR2", demographic.DisruptedSector2);
            SaveDemoRecord(demographic.AssessmentId, "CRIT-DEPEND-INCIDENT-RESPONSE", demographic.CriticalDependencyIncidentResponseSupport);


            SaveDemoRecord(demographic.AssessmentId, "STANDARD-USED", demographic.UsesStandard);
            SaveDemoRecord(demographic.AssessmentId, "STANDARD1", demographic.Standard1);
            SaveDemoRecord(demographic.AssessmentId, "STANDARD2", demographic.Standard2);
            SaveDemoRecord(demographic.AssessmentId, "REGULATION-REQD", demographic.RequiredToComply);
            SaveDemoRecord(demographic.AssessmentId, "REG-TYPE1", demographic.RegulationType1);
            SaveDemoRecord(demographic.AssessmentId, "REG-1-OTHER", demographic.Reg1Other);
            SaveDemoRecord(demographic.AssessmentId, "REG-TYPE2", demographic.RegulationType2);
            SaveDemoRecord(demographic.AssessmentId, "REG-2-OTHER", demographic.Reg2Other);

            SaveDemoRecord(demographic.AssessmentId, "SHARE-ORG", demographic.ShareOrgs);
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

        private void SaveDemoRecord(int assessmentId, string recName, int? value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                IntValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }

        private void SaveDemoRecord(int assessmentId, string recName, double value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                FloatValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }

        private void SaveDemoRecord(int assessmentId, string recName, bool value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                BoolValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }

        private void SaveDemoRecord(int assessmentId, string recName, DateTime value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                DateTimeValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }

        private void SaveDemoRecord(int assessmentId, string recName, List<int> values)
        {
            foreach (int value in values) 
            { 
                var rec = new DETAILS_DEMOGRAPHICS()
                {
                    Assessment_Id = assessmentId,
                    DataItemName = $"{recName}-{value}",
                    IntValue = value
                };

                _context.DETAILS_DEMOGRAPHICS.Add(rec);
            }
        }
    }
}
