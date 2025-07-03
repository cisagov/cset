//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Dashboard;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Dashboard;
using CSETWebCore.Model.Dashboard.BarCharts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class DashboardController : ControllerBase
    {
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name="tokenManager"></param>
        public DashboardController(CSETContext context, ITokenManager tokenManager, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _tokenManager = tokenManager;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// Returns a composite of the normalized values for the answer options in all specified models.
        /// The modelIds parameter should be delimited with vertical bar (|) characters, e.g., modelIds=23|24|25
        /// answer options.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistribs/all")]
        public IActionResult GetNormalizedAnswerDistribution([FromQuery] string modelIds)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new DashboardChartBusiness(assessmentId, _context, _assessmentUtil, _adminTabBusiness);


            // build a composite of all models
            List<DomainAnswerCount> composite = new();


            List<int> modelIdList = ParseModelIds(modelIds);

            foreach (int modelId in modelIdList)
            {
                var answerDistrib = biz.GetAnswerDistributionAll(modelId);
                foreach (DomainAnswerCount pair in answerDistrib)
                {
                    composite.Add(new DomainAnswerCount() { AnswerOptionName = pair.AnswerOptionName, AnswerCount = pair.AnswerCount });
                }
            }

            int answerCountTotal = composite.Sum(x => x.AnswerCount);

            // calc percentages
            List<NameValue> resp = new();
            var answerOptions = composite.Select(x => x.AnswerOptionName).Distinct();
            foreach (string opt in answerOptions)
            {
                var x = new NameValue() { Name = opt, Value = 0 };

                float totalForOption = composite.FindAll(x => x.AnswerOptionName == opt).Sum(x => x.AnswerCount);
                x.Value = (totalForOption / (float)answerCountTotal) * 100f;

                resp.Add(x);
            }


            return Ok(resp);
        }


        /// <summary>
        /// Returns the normalized values for the model's 
        /// answer options.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistrib/domain")]
        public IActionResult GetAnswerDistributionByDomainNormalized([FromQuery] string modelIds)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new DashboardChartBusiness(assessmentId, _context, _assessmentUtil, _adminTabBusiness);


            // build a composite of all models
            List<DomainAnswerCount> composite = new();


            List<int> modelIdList = ParseModelIds(modelIds);

            foreach (int modelId in modelIdList)
            {
                var answerDistrib = biz.GetAnswerDistributionByDomain(modelId);

                foreach (NameSeries ns in answerDistrib)
                {
                    foreach (NameValue nv in ns.Series)
                    {
                        var dac = new DomainAnswerCount();
                        dac.DomainName = ns.Name;
                        dac.AnswerOptionName = nv.Name;
                        dac.AnswerCount = (int)nv.Value;

                        composite.Add(dac);
                    }
                }
            }

            // average composite answers for the final result
            List<NameSeries> resp = new();


            var domainNames = composite.Select(x => x.DomainName).Distinct();
            var answerOpts = composite.Select(x => x.AnswerOptionName).Distinct();

            foreach (string dom in domainNames)
            {
                var totalAnswersInDomain = composite.Where(x => x.DomainName == dom).Sum(x => x.AnswerCount);

                var nsDomain = new NameSeries() { Name = dom, Series = [] };
                resp.Add(nsDomain);

                // calculate percentages for each answer option
                foreach (var opt in answerOpts)
                {
                    var totalAnswersForAnswerOption = composite.Where(x => x.DomainName == dom && x.AnswerOptionName == opt).Select(x => x.AnswerCount).Sum();
                    float avg = ((float)totalAnswersForAnswerOption / (float)totalAnswersInDomain) * 100f;

                    var nv1 = new NameValue() { Name = opt, Value = avg };
                    nsDomain.Series.Add(nv1);
                }
            }

            return Ok(resp);
        }



        /// <summary>
        /// A more targeted way to build answer distribution series for the entire model.
        /// </summary>
        /// <param name="modelIds"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistrib/model")]
        public IActionResult BuildDetailedAnswerDistribForModel([FromQuery] int modelId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var dbiz = new DashboardChartBusiness(assessmentId, _context, _assessmentUtil, _adminTabBusiness);

            var resp = dbiz.BuildFullDistributionForModel(modelId);

            return Ok(resp);
        }




        /// <summary>
        /// Converts a vertical bar-delimited list of integer values 
        /// to a List<int>.  Any non-integers are ignored.
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private List<int> ParseModelIds(string s)
        {
            List<int> intList = [];

            if (s == null)
            {
                return intList;
            }

            List<string> stringList = s.Split('|').ToList();

            for (int i = 0; i < stringList.Count; i++)
            {
                if (int.TryParse(stringList[i], out int id))
                {
                    intList.Add(id);
                }
            }

            return intList;
        }
    }
}
