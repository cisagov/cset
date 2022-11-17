//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Acet;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Maturity;
using Microsoft.AspNetCore.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Xml.XPath;
using Newtonsoft.Json;
using System.Threading.Tasks;
using NSoup.Parse;


namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class MaturityCpgController : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;


        /// <summary>
        /// 
        /// </summary>
        public MaturityCpgController(ITokenManager tokenManager, CSETContext context, IAssessmentUtil assessmentUtil,
    IAdminTabBusiness adminTabBusiness, IReportsDataBusiness reports)
        {
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
        }


        /// <summary>
        /// Returns the maturity grouping/question structure for an assessment.
        /// Specifying a query parameter of domainAbbreviation will limit the response
        /// to a single domain.
        /// </summary>
        [HttpGet]
        [Route("api/maturitystructure/cpg")]
        public IActionResult GetQuestions()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructure(assessmentId, true);


            // Break out some of the pieces of the question text for ease of use on the UI.
            // In the future it would be better to store these elements independently 
            // somehow, in a flexible way that would benefit other models.  
            var questionElements = x.Descendants("Question").ToList();
            questionElements.ForEach(q =>
            {
                var p = Parser.Parse(q.Attribute("questiontext").Value, ".");
                var cpgPractice = p.Select(".cpg-practice");
                q.SetAttributeValue("practice", cpgPractice.FirstOrDefault()?.Html());

                p = Parser.Parse(q.Attribute("supplemental").Value, ".");

                var cpgTtp = p.Select(".cpg-ttp");
                q.SetAttributeValue("ttp", cpgTtp.FirstOrDefault()?.Html());

                var cpgRec = p.Select(".cpg-recommended");
                q.SetAttributeValue("recommended", cpgRec.FirstOrDefault()?.Html());

                var cpgCsf = p.Select(".cpg-csf");

                var csfString = cpgCsf.FirstOrDefault()?.Html();
                if (csfString.IndexOf("<br") > -1)
                {
                    csfString = csfString.Substring(0, csfString.IndexOf("<br"));
                }
                var csfPieces = csfString.Split(",");
                csfString = "";
                foreach (string x in csfPieces)
                {
                    csfString += $"<span class=\"text-nowrap\">{x}</span>, ";
                }
                q.SetAttributeValue("csf", csfString.TrimEnd(" ,".ToCharArray()));


                // a few child properties can be promoted to their own named properties
                // for less complexity in the UI
                q.SetAttributeValue("cost", q.Elements("Prop").FirstOrDefault(x => x.Attribute("name").Value == "COST")?.Attribute("value").Value);
                q.SetAttributeValue("impact", q.Elements("Prop").FirstOrDefault(x => x.Attribute("name").Value == "IMPACT")?.Attribute("value").Value);
                q.SetAttributeValue("complexity", q.Elements("Prop").FirstOrDefault(x => x.Attribute("name").Value == "COMPLEXITY")?.Attribute("value").Value);
            });

            var json = Helpers.CustomJsonWriter.Serialize(x.Root);
            return Ok(json);
        }


        /// <summary>
        /// Returns the answer percentage distributions for each of the
        /// 8 CPG domains.
        /// </summary>
        [HttpGet]
        [Route("api/answerdistrib/cpg/domains")]
        public IActionResult GetAnswerDistribForDomains()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var resp = new List<AnswerDistribDomain>();

            var dbList = _context.GetAnswerDistribGroupings(assessmentId);

            foreach (var item in dbList)
            {
                if (!resp.Exists(x => x.Name == item.title))
                {
                    var domain = new AnswerDistribDomain()
                    {
                        Name = item.title,
                        Series = InitializeSeries()
                    };

                    resp.Add(domain);
                }

                double percent = CalculatePercent(dbList, item);

                var r = resp.First(x => x.Name == item.title);
                r.Series.First(x => x.Name == item.answer_text).Value = percent;
            }

            return Ok(resp);
        }


        /// <summary>
        /// Calculates the percentage based on all answer values for the domain
        /// </summary>
        /// <returns></returns>
        private double CalculatePercent(IList<GetAnswerDistribGroupingsResult> r,
            GetAnswerDistribGroupingsResult i)
        {
            var sum = r.Where(x => x.title == i.title)
                .Select(x => x.answer_count).Sum();

            return ((double)i.answer_count * 100d / (double)sum);
        }


        /// <summary>
        /// Initializes 'empty' percentge slots for potential CPG answers.
        /// </summary>
        /// <returns></returns>
        private List<Series> InitializeSeries()
        {
            var list = new List<Series>();

            var values = new List<string>() { "Y", "I", "N", "U" };
            foreach (string s in values)
            {
                list.Add(new Series()
                {
                    Name = s,
                    Value = 0
                });
            }

            return list;
        }
    }
}
