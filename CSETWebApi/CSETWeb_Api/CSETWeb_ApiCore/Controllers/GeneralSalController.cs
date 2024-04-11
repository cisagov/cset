//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Sal;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using CSETWebCore.Business;
using CSETWebCore.Business.Sal;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class GeneralSalController : ControllerBase
    {
        private readonly CSETContext _context;
        private readonly ITokenManager _token;
        private readonly IAssessmentUtil _assessmentUtil;

        /// <summary>
        /// CTOR
        /// </summary>
        public GeneralSalController(CSETContext context, ITokenManager token, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _token = token;
            _assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/GeneralSal/Descriptions")]
        public IActionResult GetGeneralSalDescriptionsWeights()
        {
            int assessmentid = _token.AssessmentForUser();

            TinyMapper.Bind<GENERAL_SAL_DESCRIPTIONS, GeneralSalDescriptionsWeights>();
            TinyMapper.Bind<GEN_SAL_WEIGHTS, GenSalWeights>();

            List<GenSalPairs> result = new List<GenSalPairs>();

            var sliders = from d in _context.GENERAL_SAL_DESCRIPTIONS
                          from g in _context.GENERAL_SAL.Where(g => g.Assessment_Id == assessmentid && g.Sal_Name == d.Sal_Name).DefaultIfEmpty()
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
                foreach (GEN_SAL_WEIGHTS w in _context.GEN_SAL_WEIGHTS.Where(x => String.Equals(x.Sal_Name, slider.d.Sal_Name)))
                {
                    s.GEN_SAL_WEIGHTS.Add(TinyMapper.Map<GenSalWeights>(w));
                    s.values.Add(" " + w.Display + " ");
                }
            }

            return Ok(result);
        }


        [HttpPost]
        [Route("api/GeneralSal/SaveWeight")]
        public IActionResult PostSaveWeight(SaveWeight ws)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            int assessmentid = _token.AssessmentForUser();
            ws.assessmentid = assessmentid;

            GeneralSalBusiness salManager = new GeneralSalBusiness(_context, _token, _assessmentUtil);
            string salvalue = salManager.SaveWeightAndCalculate(ws);

            return Ok(salvalue);
        }


        [HttpGet]
        [Route("api/GeneralSal/Value")]
        public IActionResult GetValue()
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            GeneralSalBusiness salManager = new GeneralSalBusiness(_context, _token, _assessmentUtil);

            int assessmentId = _token.AssessmentForUser();
            string salvalue = salManager.GetSavedSALValue(assessmentId);
            return Ok(salvalue);
        }


        private bool GENERAL_SALExists(int id)
        {
            return _context.GENERAL_SAL.Count(e => e.Assessment_Id == id) > 0;
        }
    }


    public class GenSalCategory
    {
        public GENERAL_SAL_DESCRIPTIONS d;
        public int? SliderValue;
    }
}
