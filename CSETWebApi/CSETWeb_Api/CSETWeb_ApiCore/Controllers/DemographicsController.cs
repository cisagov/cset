//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Demographic;
using CSETWebCore.Model.Question;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class DemographicsController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly Hooks _hooks;
        private CSETContext _context;

        private readonly TranslationOverlay _overlay;


        /// <summary>
        /// CTOR
        /// </summary>
        public DemographicsController(ITokenManager token, IAssessmentBusiness assessment,
            IDemographicBusiness demographic, Hooks hooks, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _context = context;
            _hooks = hooks;
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
            var assessmentId = _demographic.SaveDemographics(demographics);
            var stats = _hooks.HookDemographicsChanged(demographics.AssessmentId);
            var userId = _token.GetCurrentUserId();
            if (userId != null && stats != null)
            {
                return Ok(new
                {
                    AssessmentId = assessmentId,
                    CompletedCount = stats.CompletedCount,
                    TotalMaturityQuestionsCount = stats.TotalMaturityQuestionsCount ?? 0,
                    TotalDiagramQuestionsCount = stats.TotalDiagramQuestionsCount ?? 0,
                    TotalStandardQuestionsCount = stats.TotalStandardQuestionsCount ?? 0
                });
            }

            return Ok(_demographic.GetDemographics(assessmentId));
        }


        /// <summary>
        /// Get organization types
        /// </summary>
        [HttpGet]
        [Route("api/demographics/organization-types")]
        public IActionResult GetOrganizationTypes()
        {
            return Ok(_assessment.GetOrganizationTypes());
        }


        /// <summary>
        /// Get asset value options from DETAILS_DEMOGRAPHICS_OPTIONS
        /// </summary>
        [HttpGet]
        [Route("api/demographics/asset-values")]
        public async Task<IActionResult> GetAssetValues()
        {
            List<DETAILS_DEMOGRAPHICS_OPTIONS> assetValues = await _context.DETAILS_DEMOGRAPHICS_OPTIONS.Where(x => x.DataItemName == "ASSET-VALUE").ToListAsync();
            return Ok(assetValues.OrderBy(a => a.Sequence).Select(a => new DemographicsAssetValue() { AssetValue = a.OptionText, DemographicsAssetId = a.OptionValue }).ToList());
        }


        /// <summary>
        /// Get size options from DETAILS_DEMOGRAPHICS_OPTIONS
        /// </summary>
        [HttpGet]
        [Route("api/demographics/size")]
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


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext2")]
        public IActionResult GetExtended2()
        {
            var assessmentId = _token.AssessmentForUser();

            var mgr = new DemographicExtBusiness(_context);
            var response = mgr.GetExtDemographics(assessmentId);
            return Ok(response);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext2/subsectors/{id}")]
        public IActionResult GetSubsectors(int id)
        {
            var mgr = new DemographicExtBusiness(_context);
            var response = mgr.GetSubsectors(id);
            return Ok(response);
        }


        /// <summary>
        /// Persists extended demographics.
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/demographics/ext2")]
        public IActionResult PostExtended2([FromBody] DemographicExt demographics)
        {
            demographics.AssessmentId = _token.AssessmentForUser();
            var userid = _token.GetCurrentUserId();

            var mgr = new DemographicExtBusiness(_context);
            mgr.SaveDemographics(demographics, userid ?? 0);

            _hooks.HookDemographicsChanged(demographics.AssessmentId);

            return Ok();
        }


        /// <summary>
        /// Persists the sector/subsector values.  Returns a list of
        /// subsector IDs for the sector.
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/demographics/ext2/sector")]
        public IActionResult PostSector([FromBody] SectorSubsector request)
        {
            var response = new SectorChangeResponse();

            try
            {
                int assessmentId = _token.AssessmentForUser();

                var smm = new SectorMultiManager(_context);
                smm.Save(assessmentId, request);


                if (request.SectorId != null)
                {
                    var mgr = new DemographicExtBusiness(_context);
                    response.Subsectors = mgr.GetSubsectors((int)request.SectorId);
                }


                CompletionCounts stats = new CompletionCounter(_context).Count(assessmentId);
                if (stats != null)
                {
                    response.CompletedCount = stats.CompletedCount;
                    response.TotalMaturityQuestionsCount = stats.TotalMaturityQuestionsCount ?? 0;
                    response.TotalDiagramQuestionsCount = stats.TotalDiagramQuestionsCount ?? 0;
                    response.TotalStandardQuestionsCount = stats.TotalStandardQuestionsCount ?? 0;
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return Ok(response);
        }


        /// <summary>
        /// Delete a sector/subsector record from the assessment.
        /// </summary>
        /// <param name="seq"></param>
        /// <returns></returns>
        [HttpDelete]
        [Route("api/demographics/ext2/sector")]
        public IActionResult DeleteSector([FromQuery] int seq)
        {
            var response = new SectorChangeResponse();

            try
            {
                int assessmentId = _token.AssessmentForUser();

                var smm = new SectorMultiManager(_context);
                smm.Delete(assessmentId, seq);


                CompletionCounts stats = new CompletionCounter(_context).Count(assessmentId);
                if (stats != null)
                {
                    response.CompletedCount = stats.CompletedCount;
                    response.TotalMaturityQuestionsCount = stats.TotalMaturityQuestionsCount ?? 0;
                    response.TotalDiagramQuestionsCount = stats.TotalDiagramQuestionsCount ?? 0;
                    response.TotalStandardQuestionsCount = stats.TotalStandardQuestionsCount ?? 0;
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return Ok(response);
        }
    }
}
