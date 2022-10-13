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
            List<SECTOR> list = await _context.SECTOR.ToListAsync<SECTOR>();
            var tmplist = list.OrderBy(s => s.SectorName).ToList();

            var otherItem = list.Find(x => x.SectorName.Equals("other", System.StringComparison.CurrentCultureIgnoreCase));
            if (otherItem != null)
            {
                list.Remove(otherItem);
                list.Add(otherItem);
            }

            return Ok(list.Select(s => new Sector { SectorId = s.SectorId, SectorName = s.SectorName }).ToList());
        }

        [HttpGet]
        [Route("api/Demographics/Sectors_Industry")]
        // GET: api/SECTOR_INDUSTRY
        public IActionResult GetSECTOR_INDUSTRY()
        {
            return Ok(_context.SECTOR_INDUSTRY);
        }

        // GET: api/SECTOR_INDUSTRY/5
        [HttpGet]
        [Route("api/Demographics/Sectors_Industry/{id}")]
        public async Task<IActionResult> GetSECTOR_INDUSTRY(int id)
        {
            List<SECTOR_INDUSTRY> list = await _context.SECTOR_INDUSTRY.Where(x => x.SectorId == id).OrderBy(a => a.IndustryName).ToListAsync<SECTOR_INDUSTRY>();
            var otherItem = list.Find(x => x.IndustryName.Equals("other", System.StringComparison.CurrentCultureIgnoreCase));
            if (otherItem != null)
            {
                list.Remove(otherItem);
                list.Add(otherItem);
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

        //--------------------


        [HttpGet]
        [Route("api/demographics/cf")]
        public IActionResult GetDemographicsCf()
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
        [Route("api/demographics/cf/sectors")]
        public IActionResult GetSectorsCf()
        {
            var list = _context.ExtendedSector.OrderBy(x => x.SectorName).ToList();
            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/cf/subsector/{sectorId}")]
        public IActionResult GetSubsectorCf(int sectorId)
        {
            var list = _context.ExtendedSubSector.Where(x => x.SectorId == sectorId).OrderBy(x => x.SubSectorName).ToList();
            return Ok(list);
        }


        [AllowAnonymous]
        [HttpGet]
        [Route("api/demographics/cf/regions/{state}")]
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
        [Route("api/demographics/cf/counties/{state}")]
        public IActionResult GetCountyList(string state)
        {
            var list = _context.counties1.Where(x => x.State == state).ToList();
            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/cf/employees")]
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
        [Route("api/demographics/cf/customers")]
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
        [Route("api/demographics/cf/geoscope")]
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
        [Route("api/demographics/cf/cio")]
        public IActionResult GetCioOptions()
        {
            var list = new List<ListItem>();

            list.Add(new ListItem() { Id = 1, Value = "Yes, Full-Time" });
            list.Add(new ListItem() { Id = 2, Value = "Yes, Part-Time" });
            list.Add(new ListItem() { Id = 3, Value = "No" });

            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/cf/ciso")]
        public IActionResult GetCisoOptions()
        {
            var list = new List<ListItem>();

            list.Add(new ListItem() { Id = 1, Value = "Yes, Full-Time" });
            list.Add(new ListItem() { Id = 2, Value = "Yes, Part-Time" });
            list.Add(new ListItem() { Id = 3, Value = "No" });

            return Ok(list);
        }


        [HttpGet]
        [Route("api/demographics/cf/training")]
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
        [Route("api/extendeddemographics")]
        public IActionResult PostExtended([FromBody] ExtendedDemographic demographics)
        {
            demographics.AssessmentId = _token.AssessmentForUser();

            return Ok(_demographic.SaveDemographics(demographics));
        }
    }
}
