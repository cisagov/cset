//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Demographic;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;

using Microsoft.AspNetCore.Authorization;

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
            string scope = _token.Payload("scope");

            var list = await _context.SECTOR.ToListAsync<SECTOR>();


            // For now, based on the scope/skin, show either the
            // classic CISA sectors or the NIPP sectors (for IOD).
            // If NIPP becomes the preferred for all, code will
            // be added to convert CISA to NIPP on the fly.
            if (scope == "IOD")
            {
                list.RemoveAll(x => !x.Is_NIPP);
            } else
            {
                list.RemoveAll(x => x.Is_NIPP);
            }


            var otherItems = list.Where(x => x.SectorName.Equals("other", System.StringComparison.CurrentCultureIgnoreCase)).ToList();
            foreach (var o in otherItems)
            {
                list.Remove(o);
                list.Add(o);
            }

            return Ok(list.Select(s => new Sector { SectorId = s.SectorId, SectorName = s.SectorName }).ToList());
        }


        [HttpGet]
        [Route("api/Demographics/Sectors_Industry")]
        // GET: api/SECTOR_INDUSTRY
        public IActionResult GetSECTOR_INDUSTRY()
        {
            var list = _context.SECTOR_INDUSTRY;
            return Ok(list);
        }


        // GET: api/SECTOR_INDUSTRY/5
        [HttpGet]
        [Route("api/Demographics/Sectors_Industry/{id}")]
        public async Task<IActionResult> GetSECTOR_INDUSTRY(int id)
        {
            var list = await _context.SECTOR_INDUSTRY.Where(x => x.SectorId == id)
                .OrderBy(a => a.IndustryName).ToListAsync<SECTOR_INDUSTRY>();

            var otherItems = list.Where(x => x.Is_Other).ToList();
            foreach (var o in otherItems)
            {
                list.Remove(o);
                list.Add(o);
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
