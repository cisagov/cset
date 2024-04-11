//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Sal;
using CSETWebCore.Business.Standards;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Model.Sal;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Standards;
using SixLabors.ImageSharp.ColorSpaces;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class SalController : ControllerBase
    {
        private readonly CSETContext _context;
        private readonly ITokenManager _token;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IStandardsBusiness _standard;
        private readonly IStandardSpecficLevelRepository _standardRepo;
        private readonly IAssessmentModeData _assessmentModeData;


        /// <summary>
        /// CTOR
        /// </summary>
        public SalController(CSETContext context, ITokenManager token,
            IStandardsBusiness standard, IAssessmentUtil assessmentUtil, IStandardSpecficLevelRepository standardRepo,
            IAssessmentModeData assessmentModeData)
        {
            _context = context;
            _token = token;
            _standard = standard;
            _assessmentUtil = assessmentUtil;
            _standardRepo = standardRepo;
            _assessmentModeData = assessmentModeData;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/SAL")]
        public IActionResult GetSalValues()
        {
            try
            {
                int assessmentId = _token.AssessmentForUser();

                var biz = new SalBusiness(_context, _assessmentModeData, _assessmentUtil, _standard, _standardRepo);
                return Ok(biz.GetSals(assessmentId));
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return Conflict();
            }
        }


        [HttpGet]
        [Route("api/SAL/Type")]
        public async Task<IActionResult> GetType(String newType)
        {
            try
            {
                int asssessmentId = _token.AssessmentForUser();
                STANDARD_SELECTION sTANDARD_SELECTION = await _context.STANDARD_SELECTION.FindAsync(asssessmentId);
                if (sTANDARD_SELECTION != null)
                {
                    sTANDARD_SELECTION.Last_Sal_Determination_Type = newType;
                    await _context.SaveChangesAsync();
                }
                return Ok();

            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }


        [HttpPost]
        [Route("api/SAL")]
        public IActionResult PostSAL(Sals tmpsal)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            int assessmentId = _token.AssessmentForUser();
            TinyMapper.Bind<Sals, STANDARD_SELECTION>();
            STANDARD_SELECTION sTANDARD_SELECTION = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (sTANDARD_SELECTION != null)
            {
                sTANDARD_SELECTION = TinyMapper.Map<Sals, STANDARD_SELECTION>(tmpsal, sTANDARD_SELECTION);
            }
            else
            {
                sTANDARD_SELECTION = TinyMapper.Map<STANDARD_SELECTION>(tmpsal);
            }
            sTANDARD_SELECTION.Assessment_Id = assessmentId;


            _context.Entry(sTANDARD_SELECTION).State = EntityState.Modified;
            LevelManager lm = new LevelManager(assessmentId, _context);
            lm.SaveOtherLevels(assessmentId, tmpsal);
            lm.Init(sTANDARD_SELECTION);
            if (tmpsal.SelectedSALOverride)
            {
                lm.SaveSALLevel(tmpsal.Selected_Sal_Level);
            }

            try
            {
                _context.SaveChanges();

                StandardRepository sr = new StandardRepository(_standard, _assessmentModeData, _context, _assessmentUtil, _standardRepo);
                sr.InitializeStandardRepository(assessmentId);
                sr.Confidence_Level = tmpsal.CLevel;
                sr.Integrity_Level = tmpsal.ILevel;
                sr.Availability_Level = tmpsal.ALevel;

                // save the newly-calculated overall value
                if (!tmpsal.SelectedSALOverride)
                {
                    tmpsal.Selected_Sal_Level = sr.Selected_Sal_Level;
                    lm.SaveSALLevel(tmpsal.Selected_Sal_Level);
                }

                return Ok(tmpsal);
            }
            catch (DbUpdateConcurrencyException dbe)
            {
                if (!STANDARD_SELECTIONExists(assessmentId))
                {
                    return NotFound();
                }
                else
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {dbe}");

                    throw;
                }
            }
            catch (Exception e)
            {
                BadRequest(e);
            }

            return NoContent();
        }


        // POST: api/SAL
        [HttpPost]
        [Route("api/Sal_what_is_this")]
        public async Task<IActionResult> PostSTANDARD_SELECTION(STANDARD_SELECTION sTANDARD_SELECTION)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            _context.STANDARD_SELECTION.Add(sTANDARD_SELECTION);

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                if (STANDARD_SELECTIONExists(sTANDARD_SELECTION.Assessment_Id))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = sTANDARD_SELECTION.Assessment_Id }, sTANDARD_SELECTION);
        }


        [HttpGet]
        [Route("api/SAL/NistData")]
        public NistModel GetNistData()
        {
            int assessmentId = _token.AssessmentForUser();
            NistSalBusiness nistSal = new NistSalBusiness(_context, _assessmentUtil, _token);
            NistModel rvalue = new NistModel()
            {
                models = nistSal.GetInformationTypes(assessmentId),
                questions = nistSal.GetNistQuestions(assessmentId),
                specialFactors = nistSal.GetSpecialFactors(assessmentId)
            };

            return rvalue;
        }


        [HttpPost]
        [Route("api/SAL/NistData")]
        public Sals PostNistData([FromBody] NistSalModel updateValue)
        {
            int assessmentId = _token.AssessmentForUser();
            NistSalBusiness nistSal = new NistSalBusiness(_context, _assessmentUtil, _token);
            return nistSal.UpdateSalValue(updateValue, assessmentId);
        }


        [HttpPost]
        [Route("api/SAL/NistDataQuestions")]
        public Sals PostNistDataQuestions([FromBody] NistQuestionsAnswers updateValue)
        {
            int assessmentId = _token.AssessmentForUser();
            NistSalBusiness nistSal = new NistSalBusiness(_context, _assessmentUtil, _token);
            return nistSal.SaveNistQuestions(assessmentId, updateValue);
        }


        [HttpPost]
        [Route("api/SAL/NistDataSpecialFactor")]
        public Sals PostNistDataSpecialFactor([FromBody] NistSpecialFactor updateValue)
        {
            int assessmentId = _token.AssessmentForUser();
            NistSalBusiness nistSal = new NistSalBusiness(_context, _assessmentUtil, _token);
            return nistSal.SaveNistSpecialFactor(assessmentId, updateValue);
        }


        private bool STANDARD_SELECTIONExists(int id)
        {
            return _context.STANDARD_SELECTION.Count(e => e.Assessment_Id == id) > 0;
        }
    }
}
