using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Demographic;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DemographicsController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private CSETContext _context;

        public DemographicsController(ITokenManager token, IAssessmentBusiness assessment, 
            IDemographicBusiness demographic, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _context = context;
        }

        [HttpGet]
        [Route("api/demographics")]
        public IActionResult Get()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_demographic.GetDemographics(assessmentId));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/demographics")]
        public IActionResult Post([FromBody] Demographics demographics)
        {
            demographics.AssessmentId = _token.AssessmentForUser();
            return Ok(_demographic.SaveDemographics(demographics));
        }

        /// <summary>
        /// Get organization types
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getOrganizationTypes")]
        public IActionResult GetOrganizationTypes()
        {
            return Ok(_assessment.GetOrganizationTypes());
        }

        // GET: api/SECTORs
        [HttpGet]
        [Route("api/Demographics/Sectors")]
        public async Task<IActionResult> GetSECTORs()
        {
            List<SECTOR> list = await _context.SECTOR.ToListAsync<SECTOR>();
            var tmplist = list.OrderBy(s => s.SectorName).ToList();

            var otherItem = list.Find(x => x.SectorName.Equals("other", System.StringComparison.CurrentCultureIgnoreCase));
            if (otherItem != null)
            {
                list.Remove(otherItem);
                list.Add(otherItem);
            }

            return Ok(list.Select(s => new Sector { SectorId = s.SectorId, SectorName = s.SectorName }).ToList());
        }

        [HttpGet]
        [Route("api/Demographics/Sectors_Industry")]
        // GET: api/SECTOR_INDUSTRY
        public IActionResult GetSECTOR_INDUSTRY()
        {
            return Ok(_context.SECTOR_INDUSTRY);
        }

        // GET: api/SECTOR_INDUSTRY/5
        [HttpGet]
        [Route("api/Demographics/Sectors_Industry/{id}")]
        public async Task<IActionResult> GetSECTOR_INDUSTRY(int id)
        {
            List<SECTOR_INDUSTRY> list = await _context.SECTOR_INDUSTRY.Where(x => x.SectorId == id).OrderBy(a => a.IndustryName).ToListAsync<SECTOR_INDUSTRY>();
            var otherItem = list.Find(x => x.IndustryName.Equals("other", System.StringComparison.CurrentCultureIgnoreCase));
            if (otherItem != null)
            {
                list.Remove(otherItem);
                list.Add(otherItem);
            }

            return Ok(list.Select(x => new Industry() { IndustryId = x.IndustryId, IndustryName = x.IndustryName, SectorId = x.SectorId }).ToList());
        }

        [HttpGet]
        [Route("api/Demographics/AssetValues")]
        public async Task<IActionResult> GetAssetValues()
        {
            // RKW - Get the calling application (scope) to filter the appropriate asset values.
            //       The scope was set by the calling app during the login transaction and is stored in the JWT.
            string scope = _token.Payload("scope");

            List<DEMOGRAPHICS_ASSET_VALUES> assetValues = await _context.DEMOGRAPHICS_ASSET_VALUES
                .Where(x => x.AppCode == scope)
                .ToListAsync();
            return Ok(assetValues.OrderBy(a => a.ValueOrder).Select(a => new DemographicsAssetValue() { AssetValue = a.AssetValue, DemographicsAssetId = a.DemographicsAssetId }).ToList());
        }

        [HttpGet]
        [Route("api/Demographics/Size")]
        public async Task<IActionResult> GetSize()
        {
            List<DEMOGRAPHICS_SIZE> assetValues = await _context.DEMOGRAPHICS_SIZE.ToListAsync();
            return Ok(assetValues.OrderBy(a => a.ValueOrder).Select(s => new AssessmentSize() { DemographicId = s.DemographicId, Description = s.Description, Size = s.Size }).ToList());
        }
    }
}
