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
using Nelibur.ObjectMapper;

using Microsoft.AspNetCore.Authorization;
using CSETWebCore.Business.Demographic;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DemographicsExtendedController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IDemographicBusiness _demographic;
        private CSETContext _context;

        public DemographicsExtendedController(ITokenManager token, IAssessmentBusiness assessment, IAssessmentUtil assessmentUtil,
            IDemographicBusiness demographic, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _assessmentUtil = assessmentUtil;
            _demographic = demographic;
            _context = context;
        }


        /// <summary>
        /// Gets the extended demographic answers for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext")]
        public IActionResult GetExtendedDemographics()
        {
            int assessmentId = _token.AssessmentForUser();

            var demoBiz = new DemographicBusiness(_context, _assessmentUtil);
            var resp = demoBiz.GetExtendedDemographics(assessmentId);

            return Ok(resp);
        }


        /// <summary>
        /// Gets the persisted Region / County / Metro selections.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext/geographics")]
        public IActionResult GetGeographics()
        {
            int assessmentId = _token.AssessmentForUser();

            var resp = new GeographicSelections();

            _context.REGION_ANSWERS.Where(x => x.Assessment_Id == assessmentId).ToList().ForEach(x =>
            {
                resp.Regions.Add(new GeoRegion() { RegionCode = x.RegionCode, State = x.State });
            });

            _context.COUNTY_ANSWERS.Where(x => x.Assessment_Id == assessmentId).ToList().ForEach(x =>
            {
                resp.CountyFips.Add(x.County_FIPS);
            });

            _context.METRO_ANSWERS.Where(x => x.Assessment_Id == assessmentId).ToList().ForEach(x =>
            {
                resp.MetroFips.Add(x.Metro_FIPS);
            });

            return Ok(resp);
        }


        /// <summary>
        /// Returns Cyber Florida sector list
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext/sectors")]
        public IActionResult GetSectors()
        {
            var list = _context.EXT_SECTOR.OrderBy(x => x.SectorName).ToList();
            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/ext/subsector/{sectorId}")]
        public IActionResult GetSubsector(int sectorId)
        {
            var list = _context.EXT_SUB_SECTOR.Where(x => x.SectorId == sectorId).OrderBy(x => x.SubSectorName).ToList();
            return Ok(list);
        }


        [AllowAnonymous]
        [HttpGet]
        [Route("api/demographics/ext/regions/{state}")]
        public IActionResult GetRegionList(string state)
        {
            var list = new List<Model.Demographic.StateRegion>();
            TinyMapper.Bind<STATE_REGION, Model.Demographic.StateRegion>();

            var dbCounties = _context.COUNTIES.Where(x => x.State == state).OrderBy(x => x.CountyName).ToList();

            var dbRegions = _context.STATE_REGION.Where(x => x.State == state).OrderBy(x => x.RegionName).ToList();
            dbRegions.ForEach(x =>
            {
                var r = TinyMapper.Map<Model.Demographic.StateRegion>(x);

                foreach (var c in dbCounties.Where(x => x.RegionCode == r.RegionCode).ToList())
                {
                    r.Counties.Add(new County()
                    {
                        FIPS = c.County_FIPS,
                        Name = c.CountyName,
                        State = c.State
                    });
                }

                list.Add(r);
            });

            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/ext/counties/{state}")]
        public IActionResult GetCountyList(string state)
        {
            var list = _context.COUNTIES.Where(x => x.State == state).ToList();
            return Ok(list);
        }


        /// <summary>
        /// Returns all known metro areas for Florida "12-*".  
        /// TODO:  Make this smarter to know the Florida FIPS (12) so that
        /// the query can be run for any state.
        /// </summary>
        /// <param name="state"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext/metros/{state}")]
        public IActionResult GetMetroList(string state)
        {
            var list = _context.METRO_AREA
                .Include(x => x.COUNTY_METRO_AREA)
                .Where(x => x.Metro_FIPS.StartsWith("12-"))
                .ToList();

            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/ext/employees")]
        public IActionResult GetEmployeeRanges()
        {
            var list = new List<ListItem>();

            list.Add(new ListItem() { Id = 1, Value = "< 100" });
            list.Add(new ListItem() { Id = 2, Value = "101 - 250" });
            list.Add(new ListItem() { Id = 3, Value = "251 - 500" });
            list.Add(new ListItem() { Id = 4, Value = "501 - 1,000" });
            list.Add(new ListItem() { Id = 5, Value = "1,001 - 5,000" });
            list.Add(new ListItem() { Id = 6, Value = "5,001 - 10,000" });
            list.Add(new ListItem() { Id = 7, Value = "10,000 - 25,000" });
            list.Add(new ListItem() { Id = 8, Value = "> 25,000" });

            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/ext/customers")]
        public IActionResult GetCustomerRanges()
        {
            var list = new List<ListItem>();

            list.Add(new ListItem() { Id = 1, Value = "< 100" });
            list.Add(new ListItem() { Id = 2, Value = "101 - 500" });
            list.Add(new ListItem() { Id = 3, Value = "501 - 2,500" });
            list.Add(new ListItem() { Id = 4, Value = "2,501 - 10,000" });
            list.Add(new ListItem() { Id = 5, Value = "10,001 - 50,000" });
            list.Add(new ListItem() { Id = 6, Value = "50,001 - 250,000" });
            list.Add(new ListItem() { Id = 7, Value = "250,001 - 1,000,000" });
            list.Add(new ListItem() { Id = 8, Value = "1,100,001 - 5,000,000" });
            list.Add(new ListItem() { Id = 9, Value = "> 5,000,001" });

            return Ok(list);
        }

        [HttpGet]
        [Route("api/demographics/ext/geoscope")]
        public IActionResult GetGeographicScope()
        {
            var list = new List<ListItem>();

            list.Add(new ListItem() { Id = 1, Value = "No Impact" });
            list.Add(new ListItem() { Id = 2, Value = "Local (Municipality or Single County)" });
            list.Add(new ListItem() { Id = 3, Value = "Area (More than one county and less than 50% of the state)" });
            list.Add(new ListItem() { Id = 4, Value = "Statewide" });

            return Ok(list);
        }

        [HttpGet]
        [Route("api/demographics/ext/cio")]
        public IActionResult GetCioOptions()
        {
            var list = new List<ListItem>();

            list.Add(new ListItem() { Id = 1, Value = "Yes, Full-Time" });
            list.Add(new ListItem() { Id = 2, Value = "Yes, Part-Time" });
            list.Add(new ListItem() { Id = 3, Value = "No" });

            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/ext/ciso")]
        public IActionResult GetCisoOptions()
        {
            var list = new List<ListItem>();

            list.Add(new ListItem() { Id = 1, Value = "Yes, Full-Time" });
            list.Add(new ListItem() { Id = 2, Value = "Yes, Part-Time" });
            list.Add(new ListItem() { Id = 3, Value = "No" });

            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/ext/training")]
        public IActionResult GetTrainingOptions()
        {
            var list = new List<ListItem>();

            list.Add(new ListItem() { Id = 1, Value = "Yes" });
            list.Add(new ListItem() { Id = 2, Value = "No" });

            return Ok(list);
        }


        /// <summary>
        /// Persists extended demographics.
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/demographics/ext")]
        public IActionResult PostExtended([FromBody] ExtendedDemographic demographics)
        {
            demographics.AssessmentId = _token.AssessmentForUser();

            return Ok(_demographic.SaveDemographics(demographics));
        }


        /// <summary>
        /// Persists the selected region/county/metro areas.
        /// </summary>
        [HttpPost]
        [Route("api/demographics/ext/geographics")]
        public IActionResult PostGeographicLocations([FromBody] GeographicSelections geographics)
        {
            int assessmentId = _token.AssessmentForUser();

            // clean out all existing selections
            var ra = _context.REGION_ANSWERS.Where(x => x.Assessment_Id == assessmentId).ToList();
            _context.REGION_ANSWERS.RemoveRange(ra);
            var ca = _context.COUNTY_ANSWERS.Where(x => x.Assessment_Id == assessmentId).ToList();
            _context.COUNTY_ANSWERS.RemoveRange(ca);
            var ma = _context.METRO_ANSWERS.Where(x => x.Assessment_Id == assessmentId).ToList();
            _context.METRO_ANSWERS.RemoveRange(ma);
            _context.SaveChanges();

            // region_answers
            geographics.Regions.ForEach(r =>
            {
                _context.REGION_ANSWERS.Add(new REGION_ANSWERS()
                {
                    Assessment_Id = assessmentId,
                    State = r.State,
                    RegionCode = r.RegionCode
                });
            });

            // county_answers
            geographics.CountyFips.ForEach(c =>
            {
                _context.COUNTY_ANSWERS.Add(new COUNTY_ANSWERS()
                {
                    Assessment_Id = assessmentId,
                    County_FIPS = c
                });
            });

            // metro_answers
            geographics.MetroFips.ForEach(m =>
            {
                _context.METRO_ANSWERS.Add(new METRO_ANSWERS()
                {
                    Assessment_Id = assessmentId,
                    Metro_FIPS = m
                });
            });

            _context.SaveChanges();

            return Ok();
        }


        /// <summary>
        /// Returns a true if all extended demographics have been answered,
        /// otherwise a false is returned.
        /// </summary>
        [HttpGet]
        [Route("api/demographics/ext/demoanswered")]
        public IActionResult AreExtendedDemographicsAnswered()
        {
            int assessmentId = _token.AssessmentForUser();

            var demo = _context.DEMOGRAPHIC_ANSWERS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            if (demo == null)
            {
                demo = new DEMOGRAPHIC_ANSWERS();
            }

            if (demo.SectorId == null
                || demo.SubSectorId == null
                || demo.Employees == null
                || demo.CustomersSupported == null
                || demo.CIOExists == null
                || demo.CISOExists == null
                || demo.CyberTrainingProgramExists == null
                || demo.GeographicScope == null)
            {
                return Ok(false);
            }

            var regions = _context.REGION_ANSWERS.Where(x => x.Assessment_Id == assessmentId).Count();
            var counties = _context.COUNTY_ANSWERS.Where(x => x.Assessment_Id == assessmentId).Count();
            var metros = _context.METRO_ANSWERS.Where(x => x.Assessment_Id == assessmentId).Count();

            if (regions == 0 && counties == 0 && metros == 0)
            {
                return Ok(false);
            }


            return Ok(true);
        }
    }
}
