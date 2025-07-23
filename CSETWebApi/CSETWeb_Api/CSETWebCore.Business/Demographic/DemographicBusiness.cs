//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
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
        /// Gets demographics 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Demographics GetDemographics(int assessmentId)
        {
            Demographics demographics = new Demographics
            {
                AssessmentId = assessmentId
            };
           
            var extBiz = new DemographicExtBusiness(_context);
            demographics.CisaRegion = (int?)extBiz.GetX(assessmentId, "CISA-REGION");
            demographics.OrgPointOfContact = (int?)extBiz.GetX(assessmentId, "ORG-POC");
            demographics.SelfAssessment = ((bool?)extBiz.GetX(assessmentId, "SELF-ASSESS")) ?? false;
            demographics.SectorId = (int?)extBiz.GetX(assessmentId, "SECTOR");
            demographics.IndustryId = (int?)extBiz.GetX(assessmentId, "SUBSECTOR");
            demographics.CriticalService = (string?)extBiz.GetX(assessmentId, "CRIT-SERVICE");
            demographics.PointOfContact = (int?)extBiz.GetX(assessmentId, "POC");
            demographics.Agency = (string?)extBiz.GetX(assessmentId, "BUSINESS-UNIT");
            demographics.FacilitatorId = (int?)extBiz.GetX(assessmentId, "FACILITATOR");
            demographics.IsScoped = (bool?)extBiz.GetX(assessmentId, "SCOPED");
            demographics.OrganizationName = (string?)extBiz.GetX(assessmentId, "ORG-NAME");
            demographics.OrganizationType = (int?)extBiz.GetX(assessmentId, "ORG-TYPE");
            
            var assetId = (int?)extBiz.GetX(assessmentId, "ASSET-VALUE");
            var sizeId = (int?)extBiz.GetX(assessmentId, "SIZE");
            
            //Asset value and size are stored in DETAILS_DEMOGRAPHICS_OPTIONS
            if (assetId != null)
            {
                var assetValue = _context.DETAILS_DEMOGRAPHICS_OPTIONS
                    .FirstOrDefault(opt => opt.DataItemName == "ASSET-VALUE" && opt.OptionValue == assetId);
                demographics.AssetValue = assetValue.OptionValue;
            }


            if (sizeId != null)
            {
                var assetSize = _context.DETAILS_DEMOGRAPHICS_OPTIONS
                    .FirstOrDefault(opt => opt.DataItemName == "SIZE" && opt.OptionValue == sizeId);
                demographics.Size = assetSize.OptionValue;
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
            //Asset value and size are stored in DETAILS_DEMOGRAPHICS_OPTIONS
            var assetValue = _context.DETAILS_DEMOGRAPHICS_OPTIONS
                .FirstOrDefault(opt => opt.DataItemName == "ASSET-VALUE" && opt.OptionValue == demographics.AssetValue);

            var assetSize = _context.DETAILS_DEMOGRAPHICS_OPTIONS
                .FirstOrDefault(opt => opt.DataItemName == "SIZE" && opt.OptionValue == demographics.Size);
            
            // Store values in DETAILS-DEMOGRAPHICS
            var extBiz = new DemographicExtBusiness(_context);
            extBiz.SaveX(demographics.AssessmentId, "CISA-REGION", demographics.CisaRegion);
            extBiz.SaveX(demographics.AssessmentId, "ORG-POC", demographics.OrgPointOfContact);
            extBiz.SaveX(demographics.AssessmentId, "SELF-ASSESS", demographics.SelfAssessment);
            extBiz.SaveX(demographics.AssessmentId, "ORG-NAME", demographics.OrganizationName);
            extBiz.SaveX(demographics.AssessmentId, "BUSINESS-UNIT", demographics.Agency);
            extBiz.SaveX(demographics.AssessmentId, "ORG-TYPE", demographics.OrganizationType == 0 ? null : demographics.OrganizationType);
            extBiz.SaveX(demographics.AssessmentId, "SECTOR", demographics.SectorId == 0 ? null: demographics.SectorId);
            extBiz.SaveX(demographics.AssessmentId, "SUBSECTOR", demographics.IndustryId == 0 ? null: demographics.IndustryId);
            extBiz.SaveX(demographics.AssessmentId, "SECTOR-DIRECTIVE", demographics.SectorDirective);
            extBiz.SaveX(demographics.AssessmentId, "SCOPED", demographics.IsScoped);
            extBiz.SaveX(demographics.AssessmentId, "POC", demographics.PointOfContact == 0 ? null : demographics.PointOfContact);
            extBiz.SaveX(demographics.AssessmentId, "CRIT-SERVICE", demographics.CriticalService);
            extBiz.SaveX(demographics.AssessmentId, "FACILITATOR", demographics.FacilitatorId == 0 ? null : demographics.FacilitatorId);
            extBiz.SaveX(demographics.AssessmentId, "ASSET-VALUE", assetValue?.OptionValue);
            extBiz.SaveX(demographics.AssessmentId, "SIZE", assetSize?.OptionValue);
            
            _assessmentUtil.TouchAssessment(demographics.AssessmentId);

            return demographics.AssessmentId;
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