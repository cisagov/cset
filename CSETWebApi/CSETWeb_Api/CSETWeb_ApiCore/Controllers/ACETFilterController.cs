//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Model.Acet;
using CSETWebCore.Helpers;


namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ACETFilterController : ControllerBase
    {
        private readonly CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly TranslationOverlay _overlay;

        public ACETFilterController(CSETContext context, IAssessmentUtil assessmentUtil, ITokenManager tokenManager)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _tokenManager = tokenManager;

            _overlay = new TranslationOverlay();
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
            var userId = _tokenManager.GetCurrentUserId();
            var lang = _tokenManager.GetCurrentLanguage();

            try
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


                // overlay
                foreach (var d in domains)
                {
                    var o = _overlay.GetMaturityGrouping(d.DomainId, lang);
                    if (o != null)
                    {
                        d.DomainName = o.Title;
                    }
                }


                return Ok(domains);
            }
            catch (Exception ex1)
            {
                NLog.LogManager.GetCurrentClassLogger().Error(ex1);
            }

            return Ok();
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
        [Route("api/acet/filters")]
        public IActionResult GetACETFilters()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            List<ACETFilter> filters = new List<ACETFilter>();

            //full cross join
            //select DomainId, financial_level_id from FINANCIAL_DOMAINS, FINANCIAL_MATURITY
            var crossJoin = from b in _context.FINANCIAL_DOMAINS
                            from c in _context.FINANCIAL_MATURITY
                            select new { b.DomainId, c.Financial_Level_Id, b.Domain };

            var tmpFilters = (from c in crossJoin
                              join a in _context.FINANCIAL_DOMAIN_FILTERS_V2 on new { c.Financial_Level_Id, c.DomainId } equals new { a.Financial_Level_Id, a.DomainId }
                              into myFilters
                              from subfilter in myFilters.DefaultIfEmpty()
                              where subfilter.Assessment_Id == assessmentId
                              select new ACETDomainFilterSetting()
                              {
                                  DomainId = c.DomainId,
                                  DomainName = c.Domain,
                                  Financial_Level_Id = c.Financial_Level_Id,
                                  IsOn = subfilter.IsOn
                              }).ToList();


            // language overlay
            foreach (var f in tmpFilters)
            {
                var o = _overlay.GetValue("FINANCIAL_DOMAINS", f.DomainId.ToString(), lang);
                if (o != null)
                {
                    f.DomainName = o.Value;
                }
            }


            var groups = tmpFilters.GroupBy(d => d.DomainId, d => d, (key, g) => new { DomainId = key, DomainName = g.First().DomainName, Tiers = g.ToList() }).ToList();

            return Ok(groups);
        }


        /// <summary>
        /// Persists a filter setting.
        /// </summary>
        /// <param name="filterValue"></param>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/acet/savefilter")]
        public IActionResult SaveACETFilters([FromBody] ACETFilterValue filterValue)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            string domainname = filterValue.DomainName;
            int level = filterValue.Level;
            bool value = filterValue.Value;

            Dictionary<string, int> domainIds = _context.FINANCIAL_DOMAINS.ToDictionary(x => x.Domain, x => x.DomainId);
            int domainId = domainIds[domainname];

            var filter = _context.FINANCIAL_DOMAIN_FILTERS_V2.Where(x => x.DomainId == domainId && x.Assessment_Id == assessmentId && x.Financial_Level_Id == level).FirstOrDefault();
            if (filter == null)
            {
                filter = new FINANCIAL_DOMAIN_FILTERS_V2()
                {
                    Assessment_Id = assessmentId,
                    DomainId = domainId,
                    Financial_Level_Id = level,
                    IsOn = value
                };
                _context.FINANCIAL_DOMAIN_FILTERS_V2.Add(filter);
            }
            else
            {
                filter.IsOn = value;
            }

            _context.SaveChanges();
            _assessmentUtil.TouchAssessment(assessmentId);

            return Ok();
        }


        /// <summary>
        /// Persists settings for a group of filters.  This is normally used
        /// upon visiting the questions page for the first time and the filters are set based on the bands.
        /// </summary>
        /// <param name="filters"></param>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/acet/savefilters")]
        public IActionResult SaveACETFilters([FromBody] List<ACETFilter> filters)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            Dictionary<string, int> domainIds = _context.FINANCIAL_DOMAINS.ToDictionary(x => x.Domain, x => x.DomainId);
            foreach (ACETFilter f in filters)
            {

                foreach (ACETDomainTiers t in f.Tiers)
                {

                    var filter = _context.FINANCIAL_DOMAIN_FILTERS_V2.Where(x => x.DomainId == f.DomainId && x.Assessment_Id == assessmentId && x.Financial_Level_Id == t.Financial_Level_Id).FirstOrDefault();
                    if (filter == null)
                    {
                        filter = new FINANCIAL_DOMAIN_FILTERS_V2()
                        {
                            Assessment_Id = assessmentId,
                            DomainId = f.DomainId,
                            Financial_Level_Id = t.Financial_Level_Id,
                            IsOn = t.IsOn
                        };
                        _context.FINANCIAL_DOMAIN_FILTERS_V2.Add(filter);
                    }
                    else
                    {
                        filter.IsOn = t.IsOn;
                    }
                }
            }

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);

            return Ok();
        }


        /// <summary>
        /// Removes all maturity filters for the current assessment.
        /// </summary>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/acet/resetfilters")]
        public IActionResult ResetAllAcetFilters()
        {
            int assessmentID = _tokenManager.AssessmentForUser();

            var filters = _context.FINANCIAL_DOMAIN_FILTERS.Where(f => f.Assessment_Id == assessmentID).ToList();
            _context.FINANCIAL_DOMAIN_FILTERS.RemoveRange(filters);
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentID);

            return Ok();
        }
    }
}
