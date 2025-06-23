using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Business.AdminTab;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Dashboard.BarCharts;
using DocumentFormat.OpenXml.Office2019.Drawing.Model3D;
using Microsoft.AspNetCore.Mvc.ModelBinding.Metadata;


namespace CSETWebCore.Business.Dashboard
{
    /// <summary>
    /// 
    /// </summary>
    public class DashboardChartBusiness
    {
        private int _assessmentId;
        private int _modelId;
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;

        private MaturityStructureForModel _structure;

        /// <summary>
        /// Some models (CRE OPT and CRE MIL) should only include questions
        /// belonging to groupings that the user selected.  
        /// </summary>
        private List<int> _modelsWithSelectableGroupings = [23, 24];

        private bool _onlySelectedGroupings = false;

        private List<int> _selectedGroupings = [];


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name=""></param>
        public DashboardChartBusiness(int assessmentId, int modelId, CSETContext context, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness)
        {
            _assessmentId = assessmentId;
            _modelId = modelId;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;


            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            _structure = biz.GetMaturityStructureForModel(_modelId, _assessmentId);


            // if the model supports selectable groupings, build the list of selected groupings
            if (_modelsWithSelectableGroupings.Contains(_modelId))
            {
                _onlySelectedGroupings = true;
                this._selectedGroupings = _context.GROUPING_SELECTION.Where(x => x.Assessment_Id == _assessmentId).Select(x => x.Grouping_Id).ToList();
            }
        }


        /// <summary>
        /// Returns the distribution of answers for an assessment and model, normalized to 100%
        /// </summary>
        /// <returns></returns>
        public List<NameValue> GetAnswerDistributionNormalized()
        {
            // include "U" count so that we can calculate percentages.  
            _structure.Model.AnswerOptions.Add("U");
            double totalAnswerCount = _structure.AllAnswers.Count;


            // transform into our response
            var resp = new List<NameValue>();
            foreach (var ansText in _structure.Model.AnswerOptions)
            {
                var x = new NameValue
                {
                    Name = ansText,
                    Value = ((double)_structure.AllAnswers.Count(x => x.Answer_Text == ansText) * 100d) / totalAnswerCount
                };

                resp.Add(x);
            }

            resp.RemoveAll(x => x.Name == "U");

            return resp;
        }


        /// <summary>
        /// Returns a list of domains and an answer distribution (raw numbers) for each domain.
        /// We recurse down to get the questions from any groupings that are children to the domain.
        /// </summary>
        /// <returns></returns>
        public List<Model.Dashboard.BarCharts.Grouping> GetAnswerDistributionByDomain()
        {
            var resp = new List<Model.Dashboard.BarCharts.Grouping>();

            var domains = _structure.Model.Groupings;
            foreach (var item in domains)
            {
                // do not include unselected groupings for certain models
                if (_onlySelectedGroupings && !_selectedGroupings.Contains(item.GroupingId))
                {
                    continue;
                }


                var groupingIdBag = GetQuestionIdsForGrouping(item);

                resp.Add(new Model.Dashboard.BarCharts.Grouping
                {
                    Name = item.Title,
                    Series = GetAnswerCounts(groupingIdBag)
                });
            }

            return resp;
        }


        /// <summary>
        /// Recursively walks the grouping/question tree and returns a list of QuestionIds.
        /// </summary>
        /// <param name="grouping"></param>
        /// <returns></returns>
        private List<int> GetQuestionIdsForGrouping(Model.Nested.Grouping grouping)
        {
            List<int> ids = [];

            foreach (var g in grouping.Groupings)
            {
                ids.AddRange(GetQuestionIdsForGrouping(g));
            }

            ids.AddRange(grouping.Questions.Select(x => x.QuestionId).ToList());

            return ids;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionIds"></param>
        /// <returns></returns>
        public List<NameValue> GetAnswerCounts(List<int> questionIds)
        {
            var resp = new List<NameValue>();
            foreach (var ansText in _structure.Model.AnswerOptions)
            {
                var x = new NameValue
                {
                    Name = ansText,
                    Value = (double)_structure.AllAnswers.Where(x => questionIds.Contains(x.Question_Or_Requirement_Id)).Count(x => x.Answer_Text == ansText)
                };

                resp.Add(x);
            }

            return resp;
        }
    }
}
