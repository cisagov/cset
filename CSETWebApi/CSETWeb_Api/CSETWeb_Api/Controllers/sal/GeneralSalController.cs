//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.Controllers.sal;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;

namespace CSETWeb_Api.Controllers.Sal
{
    public class GeneralSalController : ApiController
    {
        private CSET_Context db = new CSET_Context();


        [Route("api/GeneralSal/Descriptions")]
        [ResponseType(typeof(List<GenSalPairs>))]
        public List<GenSalPairs> GetGeneralSalDescriptionsWeights()
        {
            int assessmentid = Auth.AssessmentForUser();

            //TODO: make this async
            TinyMapper.Bind<GENERAL_SAL_DESCRIPTIONS, GeneralSalDescriptionsWeights>();
            TinyMapper.Bind<GEN_SAL_WEIGHTS, GenSalWeights>();

            List<GenSalPairs> result = new List<GenSalPairs>();

            var sliders = from d in db.GENERAL_SAL_DESCRIPTIONS
                             from g in db.GENERAL_SAL.Where(g => g.Assessment_Id == assessmentid && g.Sal_Name == d.Sal_Name).DefaultIfEmpty()
                             orderby d.Sal_Order
                             select new GenSalCategory
                             {
                                 d = d,
                                 SliderValue = (int?)g.Slider_Value
                             };

            bool first = true;
            GenSalPairs pair = null;

            foreach (var slider in sliders.ToList())
            {
                GeneralSalDescriptionsWeights s = TinyMapper.Map<GeneralSalDescriptionsWeights>(slider.d);
                if (first)
                {
                    pair = new GenSalPairs();
                    pair.OnSite = s;
                    result.Add(pair);
                }
                else
                {
                    pair.OffSite = s;
                }
                first = !first;

                s.values = new List<string>();
                s.Slider_Value = slider.SliderValue ?? 0;
                foreach (GEN_SAL_WEIGHTS w in db.GEN_SAL_WEIGHTS.Where(x => String.Equals(x.Sal_Name, slider.d.Sal_Name)))
                {
                    s.GEN_SAL_WEIGHTS.Add(TinyMapper.Map<GenSalWeights>(w));
                    s.values.Add(" " + w.Display + " ");
                }
            }

            return result;
        }


        [Route("api/GeneralSal/SaveWeight")]
        [ResponseType(typeof(string))]
        public IHttpActionResult PostSaveWeight(SaveWeight ws)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                int assessmentid = Auth.AssessmentForUser();
                ws.assessmentid = assessmentid;
                using (CSET_Context db = new CSET_Context())
                {
                    GeneralSalManager salManager = new GeneralSalManager(db);
                    string salvalue = salManager.SaveWeightAndCalculate(ws);
                    return Ok(salvalue);
                }
            }
            catch (DbUpdateException dbe)
            {
                return (IHttpActionResult)CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(dbe, Request, HttpContext.Current);
            }
        }

        [Route("api/GeneralSal/Value")]
        [ResponseType(typeof(string))]
        public IHttpActionResult GetValue()
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                using (CSET_Context db = new CSET_Context())
                {
                    GeneralSalManager salManager = new GeneralSalManager(db);

                    int assessmentId = Auth.AssessmentForUser();
                    string salvalue = salManager.GetSavedSALValue(assessmentId);
                    return Ok(salvalue);
                }
            }
            catch (DbUpdateException dbe)
            {
                return (IHttpActionResult)CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(dbe, Request, HttpContext.Current);
            }
        }

        // DELETE: api/GeneralSal/5
        [ResponseType(typeof(GENERAL_SAL))]
        public async Task<IHttpActionResult> DeleteGENERAL_SAL(int id)
        {
            GENERAL_SAL gENERAL_SAL = await db.GENERAL_SAL.FindAsync(id);
            if (gENERAL_SAL == null)
            {
                return NotFound();
            }

            db.GENERAL_SAL.Remove(gENERAL_SAL);
            await db.SaveChangesAsync();

            return Ok(gENERAL_SAL);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool GENERAL_SALExists(int id)
        {
            return db.GENERAL_SAL.Count(e => e.Assessment_Id == id) > 0;
        }
    }


    public class GenSalCategory
    {
        public GENERAL_SAL_DESCRIPTIONS d;
        public int? SliderValue;
    }
}

