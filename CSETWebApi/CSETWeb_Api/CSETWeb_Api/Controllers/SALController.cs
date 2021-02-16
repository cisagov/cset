//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data.AssessmentData;
using CSET_Main.Data.ControlData;
using CSET_Main.SALS;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Helpers.sals;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;

namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class SALController : ApiController
    {
        private CSET_Context db = new CSET_Context();

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [Route("api/SAL")]
        [ResponseType(typeof(Sals))]
        public IHttpActionResult GetSTANDARD_SELECTION()
        {
            try
            {
                int asssessmentId = Auth.AssessmentForUser();

                TinyMapper.Bind<STANDARD_SELECTION, Sals>();
                TinyMapper.Bind<Sals, STANDARD_SELECTION>();

                STANDARD_SELECTION sTANDARD_SELECTION = db.STANDARD_SELECTION.Find(asssessmentId);
                Sals rsal;
                if (sTANDARD_SELECTION == null)
                {
                    rsal = new Sals()
                    {
                        Selected_Sal_Level = "Low",
                        Last_Sal_Determination_Type = "Simple",
                        CLevel = "Low",
                        ALevel = "Low",
                        ILevel = "Low"
                    };
                    sTANDARD_SELECTION = TinyMapper.Map<STANDARD_SELECTION>(rsal);
                    sTANDARD_SELECTION.Assessment_Id = asssessmentId;
                    sTANDARD_SELECTION.Application_Mode = AssessmentModeData.DetermineDefaultApplicationMode();
                    db.STANDARD_SELECTION.Add(sTANDARD_SELECTION);
                    db.SaveChanges();
                }
                else
                {
                    rsal = TinyMapper.Map<Sals>(sTANDARD_SELECTION);

                }

                LevelManager lm = new LevelManager(asssessmentId, db);
                lm.RetrieveOtherLevels(rsal);
                StandardRepository sr = new StandardRepository(asssessmentId, lm, new StandardManager(), new AssessmentModeData(db, asssessmentId), new StandardSpecficLevelRepository(db));
                sr.Confidence_Level = rsal.CLevel;
                sr.Integrity_Level = rsal.ILevel;
                sr.Availability_Level = rsal.ALevel;
                //if(!rsal.SelectedSALOverride)
                //   rsal.Selected_Sal_Level = sr.Selected_Sal_Level;

                return Ok(rsal);

            }
            catch (Exception)
            {
                return Conflict();
                //return (HttpResponseMessage)CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
            }

        }

        [HttpGet]
        [Route("api/SAL/Type")]
        public async Task<IHttpActionResult> GetType([FromUri] String newType)
        {
            try
            {
                int asssessmentId = Auth.AssessmentForUser();
                STANDARD_SELECTION sTANDARD_SELECTION = await db.STANDARD_SELECTION.FindAsync(asssessmentId);
                if (sTANDARD_SELECTION != null)
                {
                    sTANDARD_SELECTION.Last_Sal_Determination_Type = newType;
                    await db.SaveChangesAsync();
                }
                return Ok();

            }
            catch (Exception e)
            {
                return (IHttpActionResult)CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
            }

        }


        [Route("api/SAL")]
        [ResponseType(typeof(Sals))]
        public IHttpActionResult PostSAL(Sals tmpsal)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            int assessmentId = Auth.AssessmentForUser();
            TinyMapper.Bind<Sals, STANDARD_SELECTION>();
            STANDARD_SELECTION sTANDARD_SELECTION = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (sTANDARD_SELECTION != null)
            {
                sTANDARD_SELECTION = TinyMapper.Map<Sals, STANDARD_SELECTION>(tmpsal, sTANDARD_SELECTION);
            }
            else
            {
                sTANDARD_SELECTION = TinyMapper.Map<STANDARD_SELECTION>(tmpsal);
            }
            sTANDARD_SELECTION.Assessment_Id = assessmentId;


            db.Entry(sTANDARD_SELECTION).State = EntityState.Modified;
            LevelManager lm = new LevelManager(assessmentId, db);
            lm.SaveOtherLevels(assessmentId, tmpsal);
            lm.Init(sTANDARD_SELECTION);
            if (tmpsal.SelectedSALOverride)
            {                
                lm.SaveSALLevel(tmpsal.Selected_Sal_Level);
            }

            try
            {
                db.SaveChanges();

                StandardRepository sr = new StandardRepository(assessmentId, lm, new StandardManager(), new AssessmentModeData(db, assessmentId), new StandardSpecficLevelRepository(db));
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
                    throw dbe;
                }
            }
            catch (Exception e)
            {
                CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/SAL
        [ResponseType(typeof(STANDARD_SELECTION))]
        public async Task<IHttpActionResult> PostSTANDARD_SELECTION(STANDARD_SELECTION sTANDARD_SELECTION)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.STANDARD_SELECTION.Add(sTANDARD_SELECTION);

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
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
            int assessmentId = Auth.AssessmentForUser();
            NistSalManager nistSal = new NistSalManager();
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
            int assessmentId = Auth.AssessmentForUser();
            NistSalManager nistSal = new NistSalManager();
            return nistSal.UpdateSalValue(updateValue, assessmentId);


        }

        [HttpPost]
        [Route("api/SAL/NistDataQuestions")]
        public Sals PostNistDataQuestions([FromBody] NistQuestionsAnswers updateValue)
        {
            int assessmentId = Auth.AssessmentForUser();
            NistSalManager nistSal = new NistSalManager();
            return nistSal.SaveNistQuestions(assessmentId, updateValue);
        }

        [HttpPost]
        [Route("api/SAL/NistDataSpecialFactor")]
        [ResponseType(typeof(Sals))]
        public Sals PostNistDataSpecialFactor([FromBody] NistSpecialFactor updateValue)
        {
            int assessmentId = Auth.AssessmentForUser();
            NistSalManager nistSal = new NistSalManager();
            return nistSal.SaveNistSpecialFactor(assessmentId, updateValue);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool STANDARD_SELECTIONExists(int id)
        {
            return db.STANDARD_SELECTION.Count(e => e.Assessment_Id == id) > 0;
        }
    }

 

}

