using BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    
    public class ACETFilterController : ApiController
    {
        [HttpGet]
        [Route("api/IsAcetOnly")]
        public bool getAcetOnly()
        {
            //if the appcode is null throw an exception
            //if it is not null return the default for the app
            
            using(var db= new CSET_Context())
            {
                TokenManager tm = new TokenManager();
                string app_code = tm.Payload(Constants.Token_Scope);
                if (app_code == null)
                {
                    string ConnectionString = ((DbContext)db).Database.GetDbConnection().ConnectionString;
                    return ConnectionString.Contains("NCUAWeb");
                }
                try
                {
                    int assessment_id = Auth.AssessmentForUser();
                var ar = db.INFORMATION.Where(x => x.Id == assessment_id).FirstOrDefault();
                bool defaultAcet = (app_code == "ACET");
                    return ar.IsAcetOnly ?? defaultAcet;
                }catch(Exception e)
                {
                    return (app_code == "ACET");
                }
            }
        }

        [CSETAuthorize]
        [HttpPost]
        [Route("api/SaveIsAcetOnly")]
        public void SaveACETFilters([FromBody] bool value)
        {
            int assessment_id = Auth.AssessmentForUser();
            using (var db = new CSET_Context())
            {
                var ar = db.INFORMATION.Where(x => x.Id == assessment_id).FirstOrDefault();
                if (ar != null)
                {
                    ar.IsAcetOnly = value;
                    db.SaveChanges();
                }
            }
        }

        
        [HttpGet]
        [Route("api/ACETDomains")]
        public List<ACETDomain> getAcetDomains()
        {
            int assessmentId = Auth.AssessmentForUser();
            using (var db = new CSET_Context())
            {
                List<ACETDomain> domains = new List<ACETDomain>();
                foreach (var domain in db.FINANCIAL_DOMAINS.ToList())
                {
                    domains.Add(new ACETDomain()
                    {
                        DomainName = domain.Domain,
                        DomainId = domain.DomainId
                    });
                }
                return domains;
            }
        }


        /// <returns></returns>
        [CSETAuthorize]
        [HttpGet]
        [Route("api/GetAcetFilters")]
        public List<ACETFilter> GetACETFilters()
        {
            int assessmentId = Auth.AssessmentForUser();
            List<ACETFilter> filters = new List<ACETFilter>();
            using (CSET_Context context = new CSET_Context())
            {
                filters =  (from a in context.FINANCIAL_DOMAIN_FILTERS
                           join b in context.FINANCIAL_DOMAINS on a.DomainId equals b.DomainId
                    where a.Assessment_Id == assessmentId
                    select new ACETFilter() {
                        DomainId = a.DomainId,
                        DomainName = b.Domain,
                        B = a.B,
                        E = a.E,
                        Int = a.Int,
                        A = a.A,
                        Inn = a.Inn
                    }).ToList();
                return filters;
            }
        }

        [CSETAuthorize]
        [HttpPost]
        [Route("api/SaveAcetFilter")]
        public void SaveACETFilters([FromBody] ACETFilterValue filterValue)
        {

            int assessmentId = Auth.AssessmentForUser();
            string domainname = filterValue.DomainName;
            string field = filterValue.Field;
            bool value = filterValue.Value;

            using (CSET_Context context = new CSET_Context())
            {
                Dictionary<string, int> domainIds = context.FINANCIAL_DOMAINS.ToDictionary(x => x.Domain, x => x.DomainId);
                int domainId = domainIds[domainname];

                var filter = context.FINANCIAL_DOMAIN_FILTERS.Where(x => x.DomainId == domainId && x.Assessment_Id == assessmentId).FirstOrDefault();
                if (filter == null)
                {
                    filter = new FINANCIAL_DOMAIN_FILTERS()
                    {
                        Assessment_Id = assessmentId,
                        DomainId = domainId
                    };
                    context.FINANCIAL_DOMAIN_FILTERS.Add(filter);
                    switch (field)
                    {
                        case "B":
                            filter.B = value;
                            break;
                        case "E":
                            filter.E = value;
                            break;
                        case "Int":
                            filter.Int = value;
                            break;
                        case "A":
                            filter.A = value;
                            break;
                        case "Inn":
                            filter.Inn = value;
                            break;
                    }
                }
                else
                {
                    switch (field)
                    {
                        case "B":
                            filter.B = value;
                            break;
                        case "E":
                            filter.E = value;
                            break;
                        case "Int":
                            filter.Int = value;
                            break;
                        case "A":
                            filter.A = value;
                            break;
                        case "Inn":
                            filter.Inn = value;
                            break;
                    }
                }
                
                context.SaveChanges();
            }
        }

        [CSETAuthorize]
        [HttpPost]
        [Route("api/SaveAcetFilters")]
        public void SaveACETFilters([FromBody] List<ACETFilter> filters)
        {
            int assessmentId = Auth.AssessmentForUser();            
            using (CSET_Context context = new CSET_Context())
            {
                Dictionary<string, int> domainIds = context.FINANCIAL_DOMAINS.ToDictionary(x => x.Domain, x => x.DomainId);
                foreach(ACETFilter f in filters.Where(x => x.DomainName != null).ToList())
                {
                    int domainId = domainIds[f.DomainName];
                    var filter =  context.FINANCIAL_DOMAIN_FILTERS.Where(x => x.DomainId == domainId && x.Assessment_Id == assessmentId).FirstOrDefault();
                    if (filter == null)
                    {
                        context.FINANCIAL_DOMAIN_FILTERS.Add(new FINANCIAL_DOMAIN_FILTERS() { Assessment_Id = assessmentId, DomainId = domainId,
                            B = f.B,
                            E = f.E,
                            Int = f.Int,
                            A = f.A,
                            Inn = f.Inn
                        });
                    }
                    else
                    {
                        filter.B = f.B;
                        filter.E = f.E;
                        filter.Int = f.Int;
                        filter.A = f.A;
                        filter.Inn = f.Inn;
                    }
                }
                context.SaveChanges();            
            }
        }

        /// <summary>
        /// Removes all maturity filters for the current assessment.
        /// </summary>
        [CSETAuthorize]
        public void ResetAllAcetFilters()
        {
            int assessmentID = Auth.AssessmentForUser();
            using (CSET_Context context = new CSET_Context())
            {
                var filters = context.FINANCIAL_DOMAIN_FILTERS.Where(f => f.Assessment_Id == assessmentID).ToList();
                context.FINANCIAL_DOMAIN_FILTERS.RemoveRange(filters);
                context.SaveChanges();
            }
        }
    }

    public class ACETFilterValue
    {
        public string DomainName { get; set; }
        public String Field { get; set; }
        public bool Value { get; set; }
    }

    public class ACETFilter
    {
        public String DomainName { get; set; }
        public int DomainId { get; set; }
        public bool B { get; set; }
        public bool E { get; set; }
        public bool Int { get; set; }
        public bool A { get; set; }
        public bool Inn { get; set; }
    }

    public class ACETDomain
    {
        public string DomainName { get; set; }
        public int DomainId { get; set; }
        public string Acronym { get; set; }

    }
}
