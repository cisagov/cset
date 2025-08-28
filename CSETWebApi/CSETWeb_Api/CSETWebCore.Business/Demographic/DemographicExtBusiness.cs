//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Assessment;
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
        public DemographicExt GetExtDemographics(int assessmentId)
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

            d.CisaRegion = x.Find(z => z.DataItemName == "CISA-REGION")?.IntValue;


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

            d.CisaRegions = opts.Where(opt => opt.DataItemName == "CISA-REGION").Select(opts => new ListItem2()
            {
                OptionValue = opts.OptionValue,
                OptionText = opts.OptionText
            }).ToList();

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
        /// Convenience method for getting a single value.  Returns null if not found.
        /// </summary>
        public object GetX(int assessmentId, string recName)
        {
            var x = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == recName).FirstOrDefault();

            if (x != null)
            {
                if (x.StringValue != null)
                {
                    return x.StringValue;
                }
                if (x.IntValue != null)
                {
                    return x.IntValue;
                }
                if (x.FloatValue != null)
                {
                    return x.FloatValue;
                }
                if (x.BoolValue != null)
                {
                    return x.BoolValue;
                }
                if (x.DateTimeValue != null)
                {
                    return x.DateTimeValue;
                }
            }
            return null;
        }
        
        /// <summary>
        /// Inserts or updates a single record in DETAILS_DEMOGRAPHICS.
        /// Queries for an existing record, so not the most efficient for a bulk update.
        /// </summary>
        public void SaveX(int assessmentId, string recName, object value)
        {
            var rec = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == recName).FirstOrDefault();

            if (rec == null)
            {
                rec = new DETAILS_DEMOGRAPHICS()
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName
                };
                _context.DETAILS_DEMOGRAPHICS.Add(rec);
            }

            rec.StringValue = null;
            rec.FloatValue = null;
            rec.IntValue = null;
            rec.DateTimeValue = null;
            rec.BoolValue = null;
            if (value == null)
            {
                return;
            }

            if (value is string)
            {
                rec.StringValue = (string)value;
            }
            else if (value is int)
            {
                rec.IntValue = (int)value;
            }
            else if (value is double)
            {
                rec.FloatValue = (double)value;
            }
            else if (value is bool)
            {
                rec.BoolValue = (bool)value;
            }
            else if (value is DateTime)
            {
                rec.DateTimeValue = (DateTime)value;
            }

            _context.SaveChanges();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="demographic"></param>
        public void SaveDemographics(DemographicExt demographic, int userid)
        {
            var info = _context.INFORMATION.Where(x => x.Id == demographic.AssessmentId).FirstOrDefault();
            info.Facility_Name = demographic.OrganizationName;


            var existingRecords = _context.DETAILS_DEMOGRAPHICS
                .Where(x => x.Assessment_Id == demographic.AssessmentId)
                .ToList();

            SaveInt(demographic.AssessmentId, "ORG-TYPE", demographic.OrganizationType, existingRecords);
            SaveString(demographic.AssessmentId, "ORG-NAME", demographic.OrganizationName, existingRecords);
            SaveString(demographic.AssessmentId, "SECTOR-DIRECTIVE", demographic.SectorDirective, existingRecords);
            SaveInt(demographic.AssessmentId, "SECTOR", demographic.Sector, existingRecords);
            SaveInt(demographic.AssessmentId, "SUBSECTOR", demographic.Subsector, existingRecords);
            SaveInt(demographic.AssessmentId, "CISA-REGION", demographic.CisaRegion, existingRecords);
            SaveInt(demographic.AssessmentId, "NUM-EMP-TOTAL", demographic.NumberEmployeesTotal, existingRecords);
            SaveInt(demographic.AssessmentId, "NUM-EMP-UNIT", demographic.NumberEmployeesUnit, existingRecords);
            SaveInt(demographic.AssessmentId, "ANN-REVENUE", demographic.AnnualRevenue, existingRecords);
            SaveInt(demographic.AssessmentId, "ANN-REVENUE-PERCENT", demographic.CriticalServiceRevenuePercent, existingRecords);
            SaveInt(demographic.AssessmentId, "NUM-PEOPLE-SERVED", demographic.NumberPeopleServedByCritSvc, existingRecords);
            SaveInt(demographic.AssessmentId, "DISRUPTED-SECTOR1", demographic.DisruptedSector1, existingRecords);
            SaveInt(demographic.AssessmentId, "DISRUPTED-SECTOR2", demographic.DisruptedSector2, existingRecords);
            SaveString(demographic.AssessmentId, "CRIT-DEPEND-INCIDENT-RESPONSE", demographic.CriticalDependencyIncidentResponseSupport, existingRecords);
            SaveInt(demographic.AssessmentId, "ORG-POC", demographic.OrgPointOfContact, existingRecords);


            SaveBool(demographic.AssessmentId, "STANDARD-USED", demographic.UsesStandard, existingRecords);
            SaveString(demographic.AssessmentId, "STANDARD1", demographic.Standard1, existingRecords);
            SaveString(demographic.AssessmentId, "STANDARD2", demographic.Standard2, existingRecords);
            SaveBool(demographic.AssessmentId, "REGULATION-REQD", demographic.RequiredToComply, existingRecords);
            SaveInt(demographic.AssessmentId, "REG-TYPE1", demographic.RegulationType1, existingRecords);
            SaveString(demographic.AssessmentId, "REG-1-OTHER", demographic.Reg1Other, existingRecords);
            SaveInt(demographic.AssessmentId, "REG-TYPE2", demographic.RegulationType2, existingRecords);
            SaveString(demographic.AssessmentId, "REG-2-OTHER", demographic.Reg2Other, existingRecords);

            SaveIntList(demographic.AssessmentId, "SHARE-ORG", demographic.ShareOrgs, existingRecords);
            SaveString(demographic.AssessmentId, "SHARE-OTHER", demographic.ShareOther, existingRecords);
            SaveString(demographic.AssessmentId, "BARRIER1", demographic.Barrier1, existingRecords);
            SaveString(demographic.AssessmentId, "BARRIER2", demographic.Barrier2, existingRecords);
            SaveString(demographic.AssessmentId, "BUSINESS-UNIT", demographic.BusinessUnit, existingRecords);
            _context.SaveChanges();

            AssessmentNaming.ProcessName(_context, userid, demographic.AssessmentId);
        }


        private void SaveString(int assessmentId, string recName, string value, List<DETAILS_DEMOGRAPHICS> existing)
        {
            var target = existing.FirstOrDefault(x => x.DataItemName == recName);
            if (target == null)
            {
                var rec = new DETAILS_DEMOGRAPHICS()
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = value
                };
                _context.DETAILS_DEMOGRAPHICS.Add(rec);
            }
            else
            {
                target.StringValue = value;
            }
        }


        private void SaveInt(int assessmentId, string recName, int? value, List<DETAILS_DEMOGRAPHICS> existing)
        {
            var target = existing.FirstOrDefault(x => x.DataItemName == recName);
            if (target == null)
            {
                var rec = new DETAILS_DEMOGRAPHICS()
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    IntValue = value
                };
                _context.DETAILS_DEMOGRAPHICS.Add(rec);
            }
            else
            {
                target.IntValue = value;
            }
        }


        private void SaveDouble(int assessmentId, string recName, double value, List<DETAILS_DEMOGRAPHICS> existing)
        {
            var target = existing.FirstOrDefault(x => x.DataItemName == recName);
            if (target == null)
            {
                var rec = new DETAILS_DEMOGRAPHICS()
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    FloatValue = value
                };
                _context.DETAILS_DEMOGRAPHICS.Add(rec);
            }
            else
            {
                target.FloatValue = value;
            }
        }


        private void SaveBool(int assessmentId, string recName, bool value, List<DETAILS_DEMOGRAPHICS> existing)
        {
            var target = existing.FirstOrDefault(x => x.DataItemName == recName);
            if (target == null)
            {
                var rec = new DETAILS_DEMOGRAPHICS()
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    BoolValue = value
                };
                _context.DETAILS_DEMOGRAPHICS.Add(rec);
            }
            else
            {
                target.BoolValue = value;
            }
        }


        private void SaveDateTime(int assessmentId, string recName, DateTime value, List<DETAILS_DEMOGRAPHICS> existing)
        {
            var target = existing.FirstOrDefault(x => x.DataItemName == recName);
            if (target == null)
            {
                var rec = new DETAILS_DEMOGRAPHICS()
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    DateTimeValue = value
                };
                _context.DETAILS_DEMOGRAPHICS.Add(rec);
            }
            else
            {
                target.DateTimeValue = value;
            }
        }


        private void SaveIntList(int assessmentId, string recName, List<int> values, List<DETAILS_DEMOGRAPHICS> existing)
        {
            var xxxxxxxxx = existing.Where(x => x.DataItemName.StartsWith($"{recName}-")).ToList();

            foreach (int value in values)
            {
                var dataItemName = $"{recName}-{value}";


                var target = existing.FirstOrDefault(x => x.DataItemName == dataItemName);
                if (target == null)
                {
                    var rec = new DETAILS_DEMOGRAPHICS()
                    {
                        Assessment_Id = assessmentId,
                        DataItemName = dataItemName,
                        IntValue = value
                    };
                    _context.DETAILS_DEMOGRAPHICS.Add(rec);
                }
                else
                {
                    target.IntValue = value;
                }

                xxxxxxxxx.RemoveAll(x => x.DataItemName == dataItemName);
            }

            // look for records to remove
            // what's left in xxxxx?
            foreach (var item in xxxxxxxxx)
            {
                _context.DETAILS_DEMOGRAPHICS.Remove(item);
            }
        }
    }
}
