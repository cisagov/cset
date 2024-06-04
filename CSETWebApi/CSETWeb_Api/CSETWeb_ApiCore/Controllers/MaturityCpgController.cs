//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Helpers;


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

        private readonly TranslationOverlay _overlay;


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

            _overlay = new TranslationOverlay();
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
            var lang = _tokenManager.GetCurrentLanguage();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructure(assessmentId, true, lang);
            return Ok(x);
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
            var lang = _tokenManager.GetCurrentLanguage();

            var resp = new List<AnswerDistribDomain>();

            var dbList = _context.GetAnswerDistribGroupings(assessmentId);


            // Include any SSG questions
            IncludeSsgQuestions(assessmentId, dbList);


            foreach (var item in dbList)
            {
                // translate if necessary
                item.title = _overlay.GetMaturityGrouping(item.grouping_id, lang)?.Title ?? item.title;
                if (!resp.Exists(x => x.Name == item.title))
                {
                    var domain = new AnswerDistribDomain()
                    {
                        Name = item.title,
                        Series = InitializeSeries()
                    };

                    resp.Add(domain);
                }
            }

            // determine percentages for each answer count in the distribution
            resp.ForEach(domain =>
            {
                domain.Series.ForEach(y =>
                {
                    double percent = CalculatePercent(dbList.Where(g => g.title == domain.Name).ToList(), y.Name);
                    y.Value = percent;

                });
            });

            return Ok(resp);
        }


        /// <summary>
        /// Includes answer counts for any applicable SSG questions.
        /// </summary>
        /// <param name="list"></param>
        private void IncludeSsgQuestions(int assessmentId, IList<GetAnswerDistribGroupingsResult> list)
        {
            var mbq = new MaturityBonusQuestions(_context, assessmentId);
            var bonusModelId = mbq.BonusModelId;
            if (bonusModelId == null)
            {
                return;
            }


            // Get the answer text (and groupings from the 'base' questions)
            var bonusQuery = from bonus in _context.MQ_BONUS
                             join cpgQ in _context.MATURITY_QUESTIONS on bonus.BaseQuestionId equals cpgQ.Mat_Question_Id
                             join ans1 in _context.ANSWER on bonus.BonusQuestionId equals ans1.Question_Or_Requirement_Id into ansContainer
                             from ans in ansContainer.DefaultIfEmpty()
                             where bonus.ModelId == bonusModelId && (ans == null || ans.Question_Type == "Maturity")
                             select new { bonusQId = bonus.BonusQuestionId, answer = ans, GroupingId = cpgQ.Grouping_Id };


            // Add bonus question answers to distribution counts
            foreach (var bonusQ in bonusQuery.ToList())
            {
                var item = list.FirstOrDefault(x => x.grouping_id == bonusQ.GroupingId && x.answer_text == bonusQ.answer?.Answer_Text);

                if (item != null)
                {
                    item.answer_count++;
                }
                else
                {
                    // find the "U" item in list and increment
                    var unansweredItem = list.Where(x => x.grouping_id == bonusQ.GroupingId && x.answer_text == "U").FirstOrDefault();

                    if (unansweredItem != null)
                    {
                        unansweredItem.answer_count++;
                    }
                    else
                    {
                        // create a "U" item for the grouping
                        var newListItem = new GetAnswerDistribGroupingsResult()
                        {
                            answer_count = 1,
                            answer_text = "U",
                            grouping_id = (int)bonusQ.GroupingId
                        };
                        newListItem.title = list.Where(x => x.grouping_id == newListItem.grouping_id).FirstOrDefault()?.title;

                        list.Add(newListItem);
                    }
                }
            }
        }


        /// <summary>
        /// Calculates the percentage based on all answer values for the domain
        /// </summary>
        /// <returns></returns>
        private double CalculatePercent(List<GetAnswerDistribGroupingsResult> r, string ansName)
        {
            var target = r.FirstOrDefault(x => x.answer_text == ansName)?.answer_count ?? 0;
            var total = r.Select(x => x.answer_count).Sum();

            return ((double)target * 100d / (double)total);
        }


        /// <summary>
        /// Initializes 'empty' percentge slots for potential CPG answers.
        /// </summary>
        /// <returns></returns>
        private List<Series> InitializeSeries()
        {
            var list = new List<Series>();

            var values = new List<string>() { "Y", "I", "S", "N", "U" };
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
