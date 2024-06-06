//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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
using CSETWebCore.Helpers;


namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DemographicsController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private CSETContext _context;

        private readonly TranslationOverlay _overlay;


        /// <summary>
        /// CTOR
        /// </summary>
        public DemographicsController(ITokenManager token, IAssessmentBusiness assessment,
            IDemographicBusiness demographic, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _context = context;

            _overlay = new TranslationOverlay();
        }


        /// <summary>
        /// 
        /// </summary>
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
        [HttpGet]
        [Route("api/getOrganizationTypes")]
        public IActionResult GetOrganizationTypes()
        {
            return Ok(_assessment.GetOrganizationTypes());
        }


        /// <summary>
        /// Get SECTOR list applicable to scope (base or IOD)
        /// </summary>
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
            }
            else
            {
                list.RemoveAll(x => x.Is_NIPP);
            }

            var otherItems = list.Where(x => x.SectorName.Equals("other", System.StringComparison.CurrentCultureIgnoreCase)).ToList();
            foreach (var o in otherItems)
            {
                list.Remove(o);
                list.Add(o);
            }


            // translate if not running in english.  
            var lang = _token.GetCurrentLanguage();
            if (lang != "en")
            {
                list.ForEach(x =>
                {
                    var val = _overlay.GetValue("SECTOR", x.SectorId.ToString(), lang)?.Value;
                    if (val != null)
                    {
                        x.SectorName = val;
                    }
                });
            }


            return Ok(list.Select(s => new Sector { SectorId = s.SectorId, SectorName = s.SectorName }).ToList());
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/Demographics/Sectors_Industry")]
        public IActionResult GetSECTOR_INDUSTRY()
        {
            var list = _context.SECTOR_INDUSTRY;
            return Ok(list);
        }


        /// <summary>
        /// 
        /// </summary>
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


            // translate if not running in english.  
            var lang = _token.GetCurrentLanguage();
            if (lang != "en")
            {
                list.ForEach(x =>
                {
                    var val = _overlay.GetValue("SECTOR_INDUSTRY", x.IndustryId.ToString(), lang)?.Value;
                    if (val != null)
                    {
                        x.IndustryName = val;
                    }
                });
            }

            return Ok(list.Select(x => new Industry() { IndustryId = x.IndustryId, IndustryName = x.IndustryName, SectorId = x.SectorId }).ToList());
        }


        /// <summary>
        /// 
        /// </summary>
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


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/Demographics/StatesAndProvinces")]
        public async Task<IActionResult> GetStatesAndProvinces()
        {
            List<STATES_AND_PROVINCES> statesAndProvinces = await _context.STATES_AND_PROVINCES.ToListAsync();

            // translate if not running in english
            var lang = _token.GetCurrentLanguage();
            if (lang != "en")
            {
                statesAndProvinces.ForEach(x =>
                {
                    var val = _overlay.GetValue("STATES_AND_PROVINCES", x.STATES_AND_PROVINCES_ID.ToString(), lang)?.Value;
                    if (val != null)
                    {
                        x.Display_Name = val;
                    }
                });
            }

            return Ok(statesAndProvinces.OrderBy(s => s.Display_Name).Select(s => new StateAndProvince() 
                { 
                    StateAndProvinceId = s.STATES_AND_PROVINCES_ID, 
                    ISOCode = s.ISO_code, 
                    CountryCode = s.Country_Code, 
                    DisplayName = s.Display_Name 
                }).ToList());
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/Demographics/Size")]
        public async Task<IActionResult> GetSize()
        {
            List<DEMOGRAPHICS_SIZE> assetValues = await _context.DEMOGRAPHICS_SIZE.ToListAsync();


            // translate if not running in english
            var lang = _token.GetCurrentLanguage();
            if (lang != "en")
            {
                assetValues.ForEach(x =>
                {
                    var val = _overlay.GetValue("DEMOGRAPHICS_SIZE", x.DemographicId.ToString(), lang)?.Value;
                    if (val != null)
                    {
                        x.Description = val;
                    }
                });
            }


            return Ok(assetValues.OrderBy(a => a.ValueOrder).Select(s => new AssessmentSize() { DemographicId = s.DemographicId, Description = s.Description, Size = s.Size }).ToList());
        }
    }
}
