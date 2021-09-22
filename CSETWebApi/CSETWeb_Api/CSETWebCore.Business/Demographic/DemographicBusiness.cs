using System.Linq;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Business.Demographic
{
    public class DemographicBusiness : IDemographicBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        public DemographicBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }
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

            _assessmentUtil.TouchAssessment(dbDemographics.Assessment_Id);

            return demographics.AssessmentId;
        }
    }
}