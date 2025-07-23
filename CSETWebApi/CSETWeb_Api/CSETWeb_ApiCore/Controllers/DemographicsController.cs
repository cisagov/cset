//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Business.Authorization;
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
    [CsetAuthorize]
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
        /// Get asset value options from DETAILS_DEMOGRAPHICS_OPTIONS
        /// </summary>
        [HttpGet]
        [Route("api/Demographics/AssetValues")]
        public async Task<IActionResult> GetAssetValues()
        {
            List<DETAILS_DEMOGRAPHICS_OPTIONS> assetValues = await _context.DETAILS_DEMOGRAPHICS_OPTIONS.Where(x => x.DataItemName == "ASSET-VALUE").ToListAsync();
            return Ok(assetValues.OrderBy(a => a.Sequence).Select(a => new DemographicsAssetValue() { AssetValue = a.OptionText, DemographicsAssetId = a.OptionValue }).ToList());
        }


        /// <summary>
        /// Get size options from DETAILS_DEMOGRAPHICS_OPTIONS
        /// </summary>
        [HttpGet]
        [Route("api/Demographics/Size")]
        public async Task<IActionResult> GetSize()
        {
            List<DETAILS_DEMOGRAPHICS_OPTIONS> assetSize = await _context.DETAILS_DEMOGRAPHICS_OPTIONS.Where(x => x.DataItemName == "SIZE").ToListAsync();

            // translate if not running in english
            var lang = _token.GetCurrentLanguage();
            if (lang != "en")
            {
                assetSize.ForEach(x =>
                {
                    var val = _overlay.GetValue("DEMOGRAPHICS_SIZE", x.OptionValue.ToString(), lang)?.Value;
                    if (val != null)
                    {
                        x.OptionText = val;
                    }
                });
            }


            return Ok(assetSize.OrderBy(a => a.Sequence).Select(s => new AssessmentSize() { SizeId = s.OptionValue, Description = s.OptionText }).ToList());
        }
    }
}
