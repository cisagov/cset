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
    public class DemographicsExtendedController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private CSETContext _context;

        public DemographicsExtendedController(ITokenManager token, IAssessmentBusiness assessment,
            IDemographicBusiness demographic, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _context = context;
        }
        

        /// <summary>
        /// Gets the extended demographics for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext")]
        public IActionResult GetDemographics()
        {
            int assessmentId = _token.AssessmentForUser();

            var demo = _context.ExtendedDemographicAnswer.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            if (demo == null)
            {
                demo = new ExtendedDemographicAnswer()
                {
                    Assessment_Id = assessmentId
                };
            }

            return Ok(demo);
        }


        /// <summary>
        /// Returns Cyber Florida sector list
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/demographics/ext/sectors")]
        public IActionResult GetSectors()
        {
            var list = _context.ExtendedSector.OrderBy(x => x.SectorName).ToList();
            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/ext/subsector/{sectorId}")]
        public IActionResult GetSubsector(int sectorId)
        {
            var list = _context.ExtendedSubSector.Where(x => x.SectorId == sectorId).OrderBy(x => x.SubSectorName).ToList();
            return Ok(list);
        }


        [AllowAnonymous]
        [HttpGet]
        [Route("api/demographics/ext/regions/{state}")]
        public IActionResult GetRegionList(string state)
        {
            var list = new List<Model.Demographic.StateRegion>();
            TinyMapper.Bind<STATE_REGION, Model.Demographic.StateRegion>();

            var dbCounties = _context.counties1.Where(x => x.State == state).OrderBy(x => x.Name).ToList();

            var dbRegions = _context.STATE_REGION.Where(x => x.State == state).OrderBy(x => x.RegionName).ToList();
            dbRegions.ForEach(x =>
            {
                var r = TinyMapper.Map<Model.Demographic.StateRegion>(x);

                foreach (var c in dbCounties.Where(x => x.RegionCode == r.RegionCode).ToList())
                {
                    r.Counties.Add(new County()
                    {
                        FIPS = c.FIPS,
                        Name = c.Name,
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
            var list = _context.counties1.Where(x => x.State == state).ToList();
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
    }
}
