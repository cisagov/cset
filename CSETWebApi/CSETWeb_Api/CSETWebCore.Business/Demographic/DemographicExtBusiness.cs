//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Assessment;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Demographic;
using DocumentFormat.OpenXml.InkML;
using DocumentFormat.OpenXml.Spreadsheet;


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
        /// Saves the value as the specified type
        /// </summary>
        public void SaveX(int assessmentId, string recName, string value, string type)
        {
            switch (type)
            {
                case "int":
                    int? i = null;
                    if (value != "null")
                    {
                        i = int.Parse(value);
                    }
                    SaveX(assessmentId, recName, i);
                    break;

                case "string":
                    SaveX(assessmentId, recName, value);
                    break;

                case "double":
                    double? d = null;
                    if (value != "null")
                    {
                        d = double.Parse(value);
                    }
                    SaveX(assessmentId, recName, d);
                    break;

                case "bool":
                    bool? b = null;
                    if (value != "null")
                    {
                        b = bool.Parse(value);
                    }
                    SaveX(assessmentId, recName, b);
                    break;

                case "date":
                    SaveX(assessmentId, recName, DateTime.Parse(value));
                    break;

                default:
                    // just save it as a string
                    SaveX(assessmentId, recName, value);
                    break;
            }
        }

        /// <summary>
        /// Inserts or updates a single record in DETAILS_DEMOGRAPHICS.
        /// Queries for an existing record, so not the most efficient for a bulk update.
        /// </summary>
        public void SaveX(int assessmentId, string recName, object value)
        {
            var rec = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == recName).FirstOrDefault();

            this.ClearValues(assessmentId, recName);

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

        //Clear out corresponding DEMOGRAPHICS values if new values set by assessor
        public void ClearValues(int assessmentId, string recName)
        {
            var demo = _context.DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            var userId = _context.Assessments_For_User.Where(user => user.AssessmentId == assessmentId).FirstOrDefault();
            var user = _context.USERS.Where(user => user.UserId == userId.UserId).FirstOrDefault();
            if (user.CisaAssessorWorkflow && demo != null)
            {
                if (recName == "SECTOR")
                {
                    demo.SectorId = null;
                }
                if (recName == "ORG-TYPE")
                {
                  demo.OrganizationType = null;
                    demo.IndustryId = null;
                    
                }
                if (recName == "BUSINESS-UNIT")
                {
                    demo.Agency = null;
                }
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



            //  Clean out any existing detail records for demographics

            // list data items that we do not want to delete
            var nonDemographics = new List<string>() { "OTHER-REMARKS" };
            var oldRecords = _context.DETAILS_DEMOGRAPHICS
                .Where(x => x.Assessment_Id == demographic.AssessmentId && !nonDemographics.Contains(x.DataItemName))
                .ToList();
            if (oldRecords != null)
            {
                _context.DETAILS_DEMOGRAPHICS.RemoveRange(oldRecords);
                _context.SaveChanges();
            }
           


            // for a bit of efficiency, these methods always insert a new record without checking first

            SaveInt(demographic.AssessmentId, "ORG-TYPE", demographic.OrganizationType);
            SaveInt(demographic.AssessmentId, "SECTOR", demographic.Sector);
            SaveInt(demographic.AssessmentId, "SUBSECTOR", demographic.Subsector);
            SaveInt(demographic.AssessmentId, "CISA-REGION", demographic.CisaRegion);
            SaveInt(demographic.AssessmentId, "NUM-EMP-TOTAL", demographic.NumberEmployeesTotal);
            SaveInt(demographic.AssessmentId, "NUM-EMP-UNIT", demographic.NumberEmployeesUnit);
            SaveInt(demographic.AssessmentId, "ANN-REVENUE", demographic.AnnualRevenue);
            SaveInt(demographic.AssessmentId, "ANN-REVENUE-PERCENT", demographic.CriticalServiceRevenuePercent);
            SaveInt(demographic.AssessmentId, "NUM-PEOPLE-SERVED", demographic.NumberPeopleServedByCritSvc);
            SaveInt(demographic.AssessmentId, "DISRUPTED-SECTOR1", demographic.DisruptedSector1);
            SaveInt(demographic.AssessmentId, "DISRUPTED-SECTOR2", demographic.DisruptedSector2);
            SaveString(demographic.AssessmentId, "CRIT-DEPEND-INCIDENT-RESPONSE", demographic.CriticalDependencyIncidentResponseSupport);
            SaveInt(demographic.AssessmentId, "ORG-POC", demographic.OrgPointOfContact);


            SaveBool(demographic.AssessmentId, "STANDARD-USED", demographic.UsesStandard);
            SaveString(demographic.AssessmentId, "STANDARD1", demographic.Standard1);
            SaveString(demographic.AssessmentId, "STANDARD2", demographic.Standard2);
            SaveBool(demographic.AssessmentId, "REGULATION-REQD", demographic.RequiredToComply);
            SaveInt(demographic.AssessmentId, "REG-TYPE1", demographic.RegulationType1);
            SaveString(demographic.AssessmentId, "REG-1-OTHER", demographic.Reg1Other);
            SaveInt(demographic.AssessmentId, "REG-TYPE2", demographic.RegulationType2);
            SaveString(demographic.AssessmentId, "REG-2-OTHER", demographic.Reg2Other);

            SaveIntList(demographic.AssessmentId, "SHARE-ORG", demographic.ShareOrgs);
            SaveString(demographic.AssessmentId, "SHARE-OTHER", demographic.ShareOther);
            SaveString(demographic.AssessmentId, "BARRIER1", demographic.Barrier1);
            SaveString(demographic.AssessmentId, "BARRIER2", demographic.Barrier2);
            SaveString(demographic.AssessmentId, "BUSINESS-UNIT", demographic.BusinessUnit);
           

            _context.SaveChanges();
            AssessmentNaming.ProcessName(_context, userid, demographic.AssessmentId);
            
        }


        private void SaveString(int assessmentId, string recName, string value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                StringValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }


        private void SaveInt(int assessmentId, string recName, int? value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                IntValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }


        private void SaveDouble(int assessmentId, string recName, double value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                FloatValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }


        private void SaveBool(int assessmentId, string recName, bool value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                BoolValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }


        private void SaveDateTime(int assessmentId, string recName, DateTime value)
        {
            var rec = new DETAILS_DEMOGRAPHICS()
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                DateTimeValue = value
            };

            _context.DETAILS_DEMOGRAPHICS.Add(rec);
        }


        private void SaveIntList(int assessmentId, string recName, List<int> values)
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
