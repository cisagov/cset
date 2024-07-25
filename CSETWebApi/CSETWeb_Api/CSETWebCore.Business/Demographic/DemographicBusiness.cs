//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System.ComponentModel.DataAnnotations;
using System.Linq;
using CSETWebCore.Business.Aggregation;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Demographic;

namespace CSETWebCore.Business.Demographic
{
    public class DemographicBusiness : IDemographicBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public DemographicBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Demographics GetDemographics(int assessmentId)
        {
            Demographics demographics = new Demographics
            {
                AssessmentId = assessmentId
            };
            var query = from ddd in _context.DEMOGRAPHICS
                        from ds in _context.DEMOGRAPHICS_SIZE.Where(x => x.Size == ddd.Size).DefaultIfEmpty()
                        from dav in _context.DEMOGRAPHICS_ASSET_VALUES.Where(x => x.AssetValue == ddd.AssetValue).DefaultIfEmpty()
                        where ddd.Assessment_Id == assessmentId
                        select new { ddd, ds, dav };


            var hit = query.FirstOrDefault();
            if (hit != null)
            {
                demographics.SectorId = hit.ddd.SectorId;
                demographics.IndustryId = hit.ddd.IndustryId;
                demographics.AssetValue = hit.dav?.DemographicsAssetId;
                demographics.Size = hit.ds?.DemographicId;
                demographics.CriticalService = hit.ddd?.CriticalService;
                demographics.PointOfContact = hit.ddd?.PointOfContact;
                demographics.Agency = hit.ddd?.Agency;
                demographics.Facilitator = hit.ddd?.Facilitator;
                demographics.IsScoped = hit.ddd?.IsScoped != false;
                demographics.OrganizationName = hit.ddd?.OrganizationName;
                demographics.OrganizationType = hit.ddd?.OrganizationType;
            }


            // get any additional values we need from DETAILS_DEMOGRAPHICS
            var extBiz = new DemographicExtBusiness(_context);
            demographics.CisaRegion = (int?)extBiz.GetX(assessmentId, "CISA-REGION");
            demographics.OrgPointOfContact = (int?)extBiz.GetX(assessmentId, "ORG-POC");


            return demographics;
        }


        /// <summary>
        /// Returns the Demographics instance for the assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public AnalyticsDemographic GetAnonymousDemographics(int assessmentId)
        {
            AnalyticsDemographic demographics = new AnalyticsDemographic();

            var query = from ddd in _context.DEMOGRAPHICS
                        from s in _context.SECTOR.Where(x => x.SectorId == ddd.SectorId).DefaultIfEmpty()
                        from i in _context.SECTOR_INDUSTRY.Where(x => x.IndustryId == ddd.IndustryId).DefaultIfEmpty()
                        from ds in _context.DEMOGRAPHICS_SIZE.Where(x => x.Size == ddd.Size).DefaultIfEmpty()
                        from dav in _context.DEMOGRAPHICS_ASSET_VALUES.Where(x => x.AssetValue == ddd.AssetValue).DefaultIfEmpty()
                        where ddd.Assessment_Id == assessmentId
                        select new { ddd, ds, dav, s, i };


            var hit = query.FirstOrDefault();
            if (hit != null)
            {
                if (hit.i != null)
                {
                    demographics.IndustryId = hit.i != null ? hit.i.IndustryId : 0;
                    demographics.IndustryName = hit.i.IndustryName ?? string.Empty;
                }
                if (hit.s != null)
                {
                    demographics.SectorId = hit.s != null ? hit.s.SectorId : 0;
                    demographics.SectorName = hit.s.SectorName ?? string.Empty;

                }
                if (hit.ddd != null)
                {

                    demographics.AssetValue = hit.ddd.AssetValue ?? string.Empty;
                    demographics.Size = hit.ddd.Size ?? string.Empty;
                }
            }

            return demographics;
        }


        /// <summary>
        /// Persists data to the DEMOGRAPHICS table.
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        public int SaveDemographics(Demographics demographics)
        {
            // Convert Size and AssetValue from their keys to the strings they are stored as
            string assetValue = _context.DEMOGRAPHICS_ASSET_VALUES.Where(dav => dav.DemographicsAssetId == demographics.AssetValue).FirstOrDefault()?.AssetValue;
            string assetSize = _context.DEMOGRAPHICS_SIZE.Where(dav => dav.DemographicId == demographics.Size).FirstOrDefault()?.Size;

            this.ClearValues(demographics);

            // If the user selected nothing for sector or industry, store a null - 0 violates foreign key

            if (demographics.SectorId == 0)
            {
                demographics.SectorId = null;
            }

            if (demographics.IndustryId == 0)
            {
                demographics.IndustryId = null;
            }

            var dbDemographics = _context.DEMOGRAPHICS.Where(x => x.Assessment_Id == demographics.AssessmentId).FirstOrDefault();

            if (dbDemographics == null)
            {
                dbDemographics = new DEMOGRAPHICS()
                {
                    Assessment_Id = demographics.AssessmentId
                };
                _context.DEMOGRAPHICS.Add(dbDemographics);
                _context.SaveChanges();
            }

            dbDemographics.IndustryId = demographics.IndustryId;
            dbDemographics.SectorId = demographics.SectorId;
            dbDemographics.Size = assetSize;
            dbDemographics.AssetValue = assetValue;
            dbDemographics.Facilitator = demographics.Facilitator == 0 ? null : demographics.Facilitator;
            dbDemographics.CriticalService = demographics.CriticalService;
            dbDemographics.PointOfContact = demographics.PointOfContact == 0 ? null : demographics.PointOfContact;
            dbDemographics.IsScoped = demographics.IsScoped;
            dbDemographics.Agency = demographics.Agency;

            dbDemographics.OrganizationType = demographics.OrganizationType == 0 ? null : demographics.OrganizationType;
            dbDemographics.OrganizationName = demographics.OrganizationName;

            _context.DEMOGRAPHICS.Update(dbDemographics);
            _context.SaveChanges();
            demographics.AssessmentId = dbDemographics.Assessment_Id;



            // Not all fields are stored in DEMOGRAPHICS table ... store some in DETAILS-DEMOGRAPHICS
            var extBiz = new DemographicExtBusiness(_context);
            extBiz.SaveX(demographics.AssessmentId, "CISA-REGION", demographics.CisaRegion);
            extBiz.SaveX(demographics.AssessmentId, "ORG-POC", demographics.OrgPointOfContact);



            _assessmentUtil.TouchAssessment(dbDemographics.Assessment_Id);

            return demographics.AssessmentId;
        }

        //Clear out corresponding DETAILS_DEMOGRAPHICS values if new values set by non-assessor

        public void ClearValues(Demographics demographics)
        {
            if (demographics.SectorId != null)
            {
                var rec = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == demographics.AssessmentId && x.DataItemName == "SECTOR").FirstOrDefault();
                if (rec != null)
                {
                    _context.DETAILS_DEMOGRAPHICS.Remove(rec);
                }
                rec = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == demographics.AssessmentId && x.DataItemName == "SUBSECTOR").FirstOrDefault();
                if (rec != null)
                {
                    _context.DETAILS_DEMOGRAPHICS.Remove(rec);
                }
            }
            if (demographics.OrganizationType != null)
            {
                var rec = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == demographics.AssessmentId && x.DataItemName == "ORG-TYPE").FirstOrDefault();
                if (rec != null)
                {
                    _context.DETAILS_DEMOGRAPHICS.Remove(rec);
                }
            }
            if (demographics.Agency != null)
            {
                var rec = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == demographics.AssessmentId && x.DataItemName == "BUSINESS-UNIT").FirstOrDefault();
                if (rec != null)
                {
                    _context.DETAILS_DEMOGRAPHICS.Remove(rec);
                }
            }
            _context.SaveChanges();
        }

        /// <summary>
        /// Extended Demographics can be stored both in the DEMOGRAPHIC_ANSWERS and
        /// the DETAILS_DEMOGRAPHICS table.  
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public ExtendedDemographic GetExtendedDemographics(int assessmentId)
        {
            var demo = new ExtendedDemographic();
            demo.AssessmentId = assessmentId;

            // get values from DEMOGRAPHIC_ANSWERS (one row per assessment)
            var da = _context.DEMOGRAPHIC_ANSWERS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            if (da == null)
            {
                da = new DEMOGRAPHIC_ANSWERS();
            }

            demo.CustomersSupported = da.CustomersSupported;
            demo.CyberRiskService = da.CyberRiskService;
            demo.CioExists = da.CIOExists;
            demo.CisoExists = da.CISOExists;
            demo.Employees = da.Employees;
            demo.CyberTrainingProgramExists = da.CyberTrainingProgramExists;
            demo.GeographicScope = da.GeographicScope;
            demo.SectorId = da.SectorId;
            demo.SubSectorId = da.SubSectorId;


            // get values from DETAILS_DEMOGRAPHICS (multiple name/value rows per assessment)
            var demogBiz = new DemographicBusiness(_context, _assessmentUtil);
            demo.Hb7055 = demogBiz.GetDD(assessmentId, "HB-7055");
            demo.Hb7055Party = demogBiz.GetDD(assessmentId, "HB-7055-PARTY");
            demo.Hb7055Grant = demogBiz.GetDD(assessmentId, "HB-7055-GRANT");
            demo.InfrastructureItOt = demogBiz.GetDD(assessmentId, "INFRA-IT-OT");

            return demo;
        }


        /// <summary>
        /// Persists data to the ExtendedDemographicAnswer database table.
        /// Also saves data to DETAILS_DEMOGRAPHICS.
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        public int SaveDemographics(Model.Demographic.ExtendedDemographic demographics)
        {
            var dbDemog = _context.DEMOGRAPHIC_ANSWERS.Where(x => x.Assessment_Id == demographics.AssessmentId).FirstOrDefault();
            if (dbDemog == null)
            {
                dbDemog = new DEMOGRAPHIC_ANSWERS()
                {
                    Assessment_Id = demographics.AssessmentId
                };
                _context.DEMOGRAPHIC_ANSWERS.Add(dbDemog);
                _context.SaveChanges();
            }

            dbDemog.SectorId = demographics.SectorId;
            dbDemog.SubSectorId = demographics.SubSectorId;
            dbDemog.Employees = demographics.Employees;
            dbDemog.CustomersSupported = demographics.CustomersSupported;
            dbDemog.GeographicScope = demographics.GeographicScope;
            dbDemog.CIOExists = demographics.CioExists;
            dbDemog.CISOExists = demographics.CisoExists;
            dbDemog.CyberTrainingProgramExists = demographics.CyberTrainingProgramExists;
            dbDemog.CyberRiskService = demographics.CyberRiskService;

            _context.DEMOGRAPHIC_ANSWERS.Update(dbDemog);
            _context.SaveChanges();


            // save demographic answers that live in DETAILS_DEMOGRAPHICS
            SaveDD(demographics.AssessmentId, "HB-7055", demographics.Hb7055, null);
            SaveDD(demographics.AssessmentId, "HB-7055-PARTY", demographics.Hb7055Party, null);
            SaveDD(demographics.AssessmentId, "INFRA-IT-OT", demographics.InfrastructureItOt, null);
            SaveDD(demographics.AssessmentId, "HB-7055-GRANT", demographics.Hb7055Grant, null);


            _assessmentUtil.TouchAssessment(dbDemog.Assessment_Id);

            return dbDemog.Assessment_Id;
        }


        /// <summary>
        /// Retrieves a DETAILS_DEMOGRAPHICS record for the assessment.
        /// </summary>
        /// <returns></returns>
        public string GetDD(int assessmentId, string key)
        {
            var dd = _context.DETAILS_DEMOGRAPHICS
               .Where(x => x.Assessment_Id == assessmentId && x.DataItemName == key).FirstOrDefault();

            if (dd != null)
            {
                return dd.StringValue;
            }

            return null;
        }


        /// <summary>
        /// Persists a DETAILS_DEMOGRAPHICS record for the assessment.
        /// Replaces an existing record; does not create another one with the same name.
        /// TODO:  implement a datatype option.
        /// </summary>
        public void SaveDD(int assessmentId, string key, string value, string dataType)
        {
            var dd = _context.DETAILS_DEMOGRAPHICS
               .Where(x => x.Assessment_Id == assessmentId && x.DataItemName == key).FirstOrDefault();

            if (dd == null)
            {
                dd = new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = key
                };
                _context.DETAILS_DEMOGRAPHICS.Add(dd);
            }

            dd.StringValue = value;
            _context.SaveChanges();
        }
    }
}