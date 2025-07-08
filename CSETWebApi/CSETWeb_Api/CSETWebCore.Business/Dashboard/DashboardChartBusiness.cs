using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Dashboard;
using CSETWebCore.Model.Dashboard.BarCharts;
using System;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Dashboard
{
    /// <summary>
    /// 
    /// </summary>
    public class DashboardChartBusiness
    {
        private int _assessmentId;
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;


        /// <summary>
        /// Some models (CRE OPT and CRE MIL) should only include questions
        /// belonging to groupings that the user selected.  
        /// </summary>
        private List<int> _modelsWithSelectableGroupings = [23, 24];

        private List<int> _selectedGroupings = [];

        private MaturityBusiness _biz;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name=""></param>
        public DashboardChartBusiness(int assessmentId, CSETContext context, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness)
        {
            _assessmentId = assessmentId;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;


            _biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            // A list of selected grouping IDs, regardless of model
            _selectedGroupings = _context.GROUPING_SELECTION.Where(x => x.Assessment_Id == _assessmentId).Select(x => x.Grouping_Id).ToList();
        }


        /// <summary>
        /// Returns the distribution of answers for an assessment and model, normalized to 100%
        /// </summary>
        /// <returns></returns>
        public List<DomainAnswerCount> GetAnswerDistributionAll(int modelId)
        {
            // flesh out model-specific questions 
            _context.FillEmptyMaturityQuestionsForModel(_assessmentId, modelId);

            var structure = _biz.GetMaturityStructureForModel(modelId, _assessmentId);

            // include "U" count so that we can calculate percentages.  
            structure.Model.AnswerOptions.Add("U");


            var countableQuestionIds = structure.allQuestions.Select(x => x.Mat_Question_Id);
            var countableAnswers = structure.AllAnswers;

            // don't count questions in unselected groupings for models that require groupings to be selected
            if (_modelsWithSelectableGroupings.Contains(modelId))
            {
                countableQuestionIds = structure.allQuestions.Where(q => _selectedGroupings.Contains((int)q.Grouping_Id)).Select(x => x.Mat_Question_Id);
                countableAnswers.RemoveAll(x => !countableQuestionIds.Contains(x.Question_Or_Requirement_Id));
            }


            var resp = new List<DomainAnswerCount>();
            foreach (var ansText in structure.Model.AnswerOptions)
            {
                var dac = new DomainAnswerCount();
                dac.DomainName = "ALL";
                dac.AnswerOptionName = ansText;
                dac.AnswerCount = countableAnswers.Count(x => x.Answer_Text == ansText);

                resp.Add(dac);
            }

            return resp;
        }


        /// <summary>
        /// Returns a list of domains and a normalized answer distribution (percentages) for each domain.
        /// We recurse down to get the questions from any groupings that are children to the domain.
        /// </summary>
        /// <returns></returns>
        public List<NameSeries> GetAnswerDistributionByDomain(int modelId)
        {
            var resp = new List<NameSeries>();

            var structure = _biz.GetMaturityStructureForModel(modelId, _assessmentId);
            structure.Model.AnswerOptions.Add("U");

            var domains = structure.Model.Groupings;

            foreach (var item in domains)
            {
                var questionIdBag = GetQuestionIdsForGrouping(modelId, item);

                resp.Add(new NameSeries
                {
                    Name = item.Title,
                    Series = GetAnswerCounts(modelId, questionIdBag, structure)
                });
            }

            return resp;
        }


        /// <summary>
        /// Recursively walks the grouping/question tree and returns a list of QuestionIds.
        /// </summary>
        /// <param name="grouping"></param>
        /// <returns></returns>
        private List<int> GetQuestionIdsForGrouping(int modelId, Model.Nested.Grouping grouping)
        {
            List<int> ids = [];

            foreach (var g in grouping.Groupings)
            {
                ids.AddRange(GetQuestionIdsForGrouping(modelId, g));
            }

            // don't count questions in unselected groupings for models that require groupings to be selected
            if (_modelsWithSelectableGroupings.Contains(modelId) && !_selectedGroupings.Contains(grouping.GroupingId))
            {
                return ids;
            }

            ids.AddRange(grouping.Questions.Select(x => x.QuestionId).ToList());

            return ids;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionIds"></param>
        /// <returns></returns>
        public List<NameValue> GetAnswerCounts(int modelId, List<int> questionIds, MaturityStructureForModel structure)
        {
            var resp = new List<NameValue>();

            foreach (var ansText in structure.Model.AnswerOptions)
            {
                var x = new NameValue
                {
                    Name = ansText,
                    Value = (double)structure.AllAnswers.Where(x => questionIds.Contains(x.Question_Or_Requirement_Id)).Count(x => x.Answer_Text == ansText)
                };

                resp.Add(x);
            }

            return resp;
        }




        /// <summary>
        /// Creates the entire tree of answer distributions for a model within an assessment.
        /// </summary>
        public List<NameSeriesCount> BuildFullDistributionForModel(int modelId)
        {
            List<NameSeriesCount> resp = [];

            var mbiz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var structure = mbiz.GetMaturityStructureForModel(modelId, _assessmentId);

            // Include 'U' as an answer option for complete results
            if (!structure.Model.AnswerOptions.Contains("U"))
            {
                structure.Model.AnswerOptions.Add("U");
            }

            // start with the groupings (domains) at the top of the model
            foreach (var grp in structure.Model.Groupings)
            {
                var domainDetails = BuildGroupingDetails(grp, structure);

                // do not include domains with no applicable subdomains
                if (domainDetails.Subgroups.Count == 0)
                {
                    continue;
                }


                resp.Add(domainDetails);
            }

            return resp;
        }


        /// <summary>
        /// Recurses a Grouping and builds a tree with all domains and subdomains 
        /// and thier question distributions.
        /// </summary>
        /// <param name="g"></param>
        /// <param name="structure"></param>
        /// <returns></returns>
        public NameSeriesCount BuildGroupingDetails(Model.Nested.Grouping g, MaturityStructureForModel structure)
        {
            var resp = new NameSeriesCount();
            resp.Name = g.Title;
            resp.Series = BuildSeries(g, structure);

            foreach (var subgroup in g.Groupings)
            {
                if (_modelsWithSelectableGroupings.Contains(structure.Model.ModelId) && !_selectedGroupings.Contains(subgroup.GroupingId))
                {
                    continue;
                }

                resp.Subgroups.Add(BuildGroupingDetails(subgroup, structure));
            }

            return resp;
        }


        /// <summary>
        /// Creates a list of name-value pairs containing answer counts and percentages.
        /// </summary>
        private List<NameValueCount> BuildSeries(Model.Nested.Grouping g, MaturityStructureForModel structure)
        {
            List<NameValueCount> list = [];

            foreach (var ansText in structure.Model.AnswerOptions)
            {
                var i = new NameValueCount();
                i.Name = ansText;
                i.Count = structure.AllAnswers.Where(x => g.Questions.Select(x => x.QuestionId).Contains(x.Question_Or_Requirement_Id)).Count(x => x.Answer_Text == ansText);

                list.Add(i);
            }


            // Calculate percentages based on the counts
            var ansCountTotal = list.Sum(x => x.Count);
            foreach (var l in list)
            {
                if (ansCountTotal == 0)
                {
                    l.Value = 0;
                    continue;
                }

                l.Value = ((float)l.Count / (float)ansCountTotal) * 100f;
            }

            return list;
        }
    }
}
