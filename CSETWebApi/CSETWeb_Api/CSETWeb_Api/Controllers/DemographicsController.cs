//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;


namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class DemographicsController : ApiController
    {
        private CsetwebContext db = new CsetwebContext();

        /// <summary>
        /// Assessment demographics.
        /// </summary>
        public DemographicsController() : base()
        {
           
        }

        /// <summary>
        /// Returns an instance of Demographics for the 
        /// </summary>        
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics")]
        public Demographics Get()
        {
            int assessmentId = Auth.AssessmentForUser();
            AssessmentManager assessmentManager = new AssessmentManager();
            return assessmentManager.GetDemographics(assessmentId);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/demographics")]
        public int Post([FromBody]Demographics demographics)
        {   
            demographics.AssessmentId = Auth.AssessmentForUser();
            AssessmentManager assessmentManager = new AssessmentManager();
            return assessmentManager.SaveDemographics(demographics);
        }

        

        #region Getters for the demographics
        // GET: api/SECTORs
        [Route("api/Demographics/Sectors")]
        public async Task<List<Sector>> GetSECTORs()
        {
            List<SECTOR> list = await db.SECTOR.ToListAsync<SECTOR>();
            var tmplist = list.OrderBy(s => s.SectorName).ToList();

            var otherItem = list.Find(x => x.SectorName.Equals("other", System.StringComparison.CurrentCultureIgnoreCase));
            if (otherItem != null)
            {
                list.Remove(otherItem);
                list.Add(otherItem);
            }

            return list.Select(s => new Sector { SectorId = s.SectorId, SectorName = s.SectorName }).ToList();
        }

        [Route("api/Demographics/Sectors_Industry")]
        // GET: api/SECTOR_INDUSTRY
        public IQueryable<SECTOR_INDUSTRY> GetSECTOR_INDUSTRY()
        {
            return db.SECTOR_INDUSTRY;
        }

        // GET: api/SECTOR_INDUSTRY/5
        [Route("api/Demographics/Sectors_Industry/{id}")]        
        public async Task<List<Industry>> GetSECTOR_INDUSTRY(int id)
        {
            List<SECTOR_INDUSTRY> list = await db.SECTOR_INDUSTRY.Where(x => x.SectorId == id).OrderBy(a => a.IndustryName).ToListAsync<SECTOR_INDUSTRY>();
            var otherItem = list.Find(x => x.IndustryName.Equals("other", System.StringComparison.CurrentCultureIgnoreCase));
            if (otherItem != null)
            {
                list.Remove(otherItem);
                list.Add(otherItem);
            }
            
            return list.Select(x => new Industry() { IndustryId = x.IndustryId, IndustryName = x.IndustryName, SectorId = x.SectorId }).ToList();
        }

        [Route("api/Demographics/AssetValues")]
        public async Task<List<DemographicsAssetValue>> GetAssetValues()
        {
            List<DEMOGRAPHICS_ASSET_VALUES> assetValues = await db.DEMOGRAPHICS_ASSET_VALUES.ToListAsync<DEMOGRAPHICS_ASSET_VALUES>();
            return assetValues.OrderBy(a => a.ValueOrder).Select(a => new DemographicsAssetValue() { AssetValue = a.AssetValue, DemographicsAssetId = a.DemographicsAssetId }).ToList();
        }

        [Route("api/Demographics/Size")]
        public async Task<List<AssessmentSize>> GetSize()
        {
            List<DEMOGRAPHICS_SIZE> assetValues = await db.DEMOGRAPHICS_SIZE.ToListAsync<DEMOGRAPHICS_SIZE>();
            return assetValues.OrderBy(a => a.ValueOrder).Select(s => new AssessmentSize() { DemographicId = s.DemographicId, Description = s.Description, Size = s.Size }).ToList();
        }
        #endregion
    }

    public interface GetName
    {
        string Name { get;}
    }

    public class Industry:GetName
    {
        public int SectorId { get; set; }
        public int IndustryId { get; set; }
        public string IndustryName { get; set; }
        public string Name { get { return IndustryName; } }
    }

    public class AssessmentSize
    {
        public int DemographicId { get; set; }
        public string Size { get; set; }
        public string Description { get; set; }
    }

    public class DemographicsAssetValue
    {
        public int DemographicsAssetId { get; set; }
        public string AssetValue { get; set; }
    }


    public class Sector:GetName
    {
        public int SectorId { get; set; }
        public string SectorName { get; set; }

        public string Name
        {
            get { return SectorName; }
        }
    }
}


