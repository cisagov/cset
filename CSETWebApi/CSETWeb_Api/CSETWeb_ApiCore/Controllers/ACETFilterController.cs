using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Authorization;
using CSETWebCore.Model.Acet;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ACETFilterController : ControllerBase
    {
        private readonly CSETContext _context;
        private readonly ITokenManager _tokenManager;

        public ACETFilterController(CSETContext context, ITokenManager tokenManager)
        {
            _context = context;
            _tokenManager = tokenManager;
        }

        [HttpGet]
        [Route("api/IsAcetOnly")]
        public IActionResult GetAcetOnly()
        {
            //if the appcode is null throw an exception
            //if it is not null return the default for the app

            string app_code = _tokenManager.Payload(Constants.Constants.Token_Scope);
            if (app_code == null)
            {
                string ConnectionString = _context.Database.GetDbConnection().ConnectionString;
                return Ok(ConnectionString.Contains("NCUAWeb"));
            }
            try
            {
                int assessment_id = _tokenManager.AssessmentForUser();
                var ar = _context.INFORMATION.Where(x => x.Id == assessment_id).FirstOrDefault();
                bool defaultAcet = (app_code == "ACET");
                return Ok(ar.IsAcetOnly ?? defaultAcet);
            }
            catch (Exception)
            {
                return Ok(app_code == "ACET");
            }
        }


        [CsetAuthorize]
        [HttpPost]
        [Route("api/SaveIsAcetOnly")]
        public IActionResult SaveACETFilters([FromBody] bool value)
        {
            int assessment_id = _tokenManager.AssessmentForUser();
           
            var ar = _context.INFORMATION.Where(x => x.Id == assessment_id).FirstOrDefault();
            if (ar != null)
            {
                ar.IsAcetOnly = value;
                _context.SaveChanges();
            }

            return Ok();
        }


        [HttpGet]
        [Route("api/ACETDomains")]
        public IActionResult GetAcetDomains()
        {
            List<ACETDomain> domains = new List<ACETDomain>();
            foreach (var domain in _context.FINANCIAL_DOMAINS.ToList())
            {
                domains.Add(new ACETDomain()
                {
                    DomainName = domain.Domain,
                    DomainId = domain.DomainId
                });
            }
            return Ok(domains);
        }


        /// <summary>
        /// Returns known filter settings.  The columns in the FINANCIAL_DOMAIN_FILTERS
        /// are "hard-coded" as B, E, Int, A and Inn.  This method genericizes them
        /// to their numeric equivalent.  If CSET implements a new maturity model
        /// in the future that wants domain-level maturity filtering, we will need
        /// the generic numbers, rather than the ACET names.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [HttpGet]
        [Route("api/GetAcetFilters")]
        public IActionResult GetACETFilters()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            List<ACETFilter> filters = new List<ACETFilter>();

            filters = (from a in _context.FINANCIAL_DOMAIN_FILTERS
                       join b in _context.FINANCIAL_DOMAINS on a.DomainId equals b.DomainId
                       where a.Assessment_Id == assessmentId
                       select new ACETFilter()
                       {
                           DomainId = a.DomainId,
                           DomainName = b.Domain,
                           B = a.B,
                           E = a.E,
                           Int = a.Int,
                           A = a.A,
                           Inn = a.Inn
                       }).ToList();

            // create Settings according to the B, E, Int, A and Inn bits.
            filters.ForEach(f =>
            {
                f.Settings = new List<ACETFilterSetting>();
                f.Settings.Add(new ACETFilterSetting(1, f.B));
                f.Settings.Add(new ACETFilterSetting(2, f.E));
                f.Settings.Add(new ACETFilterSetting(3, f.Int));
                f.Settings.Add(new ACETFilterSetting(4, f.A));
                f.Settings.Add(new ACETFilterSetting(5, f.Inn));
            });

            return Ok(filters);
        }


        /// <summary>
        /// Persists a filter setting.
        /// </summary>
        /// <param name="filterValue"></param>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/SaveAcetFilter")]
        public IActionResult SaveACETFilters([FromBody] ACETFilterValue filterValue)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            string domainname = filterValue.DomainName;
            int level = filterValue.Level;
            bool value = filterValue.Value;

            Dictionary<string, int> domainIds = _context.FINANCIAL_DOMAINS.ToDictionary(x => x.Domain, x => x.DomainId);
            int domainId = domainIds[domainname];

            var filter = _context.FINANCIAL_DOMAIN_FILTERS.Where(x => x.DomainId == domainId && x.Assessment_Id == assessmentId).FirstOrDefault();
            if (filter == null)
            {
                filter = new FINANCIAL_DOMAIN_FILTERS()
                {
                    Assessment_Id = assessmentId,
                    DomainId = domainId
                };
                _context.FINANCIAL_DOMAIN_FILTERS.Add(filter);
            }

            switch (level)
            {
                case 1:
                    filter.B = value;
                    break;
                case 2:
                    filter.E = value;
                    break;
                case 3:
                    filter.Int = value;
                    break;
                case 4:
                    filter.A = value;
                    break;
                case 5:
                    filter.Inn = value;
                    break;
            }

            _context.SaveChanges();
            return Ok();
        }


        /// <summary>
        /// Persists settings for a group of filters.  This is normally used
        /// upon visiting the questions page for the first time and the filters are set based on the bands.
        /// </summary>
        /// <param name="filters"></param>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/SaveAcetFilters")]
        public IActionResult SaveACETFilters([FromBody] List<ACETFilter> filters)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            
            Dictionary<string, int> domainIds = _context.FINANCIAL_DOMAINS.ToDictionary(x => x.Domain, x => x.DomainId);
            foreach (ACETFilter f in filters.Where(x => x.DomainName != null).ToList())
            {
                int domainId = domainIds[f.DomainName];
                var filter = _context.FINANCIAL_DOMAIN_FILTERS.Where(x => x.DomainId == domainId && x.Assessment_Id == assessmentId).FirstOrDefault();
                if (filter == null)
                {
                    filter = new FINANCIAL_DOMAIN_FILTERS()
                    {
                        Assessment_Id = assessmentId,
                        DomainId = domainId
                    };
                    _context.FINANCIAL_DOMAIN_FILTERS.Add(filter);
                }

                foreach (var s in f.Settings)
                {
                    switch (s.Level)
                    {
                        case 1:
                            filter.B = s.Value;
                            break;
                        case 2:
                            filter.E = s.Value;
                            break;
                        case 3:
                            filter.Int = s.Value;
                            break;
                        case 4:
                            filter.A = s.Value;
                            break;
                        case 5:
                            filter.Inn = s.Value;
                            break;
                    }
                }
            }

            _context.SaveChanges();
            return Ok();
        }


        /// <summary>
        /// Removes all maturity filters for the current assessment.
        /// </summary>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/resetAcetFilters")]
        public IActionResult ResetAllAcetFilters()
        {
            int assessmentID = _tokenManager.AssessmentForUser();

            var filters = _context.FINANCIAL_DOMAIN_FILTERS.Where(f => f.Assessment_Id == assessmentID).ToList();
            _context.FINANCIAL_DOMAIN_FILTERS.RemoveRange(filters);
            _context.SaveChanges();
            return Ok();
        }
    }
}
