//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Model.Nested;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// Bare bones grouping structure with scores and charts.
    /// </summary>
    public class CisScoringStructure
    {
        private readonly CSETContext _context;
        private int _assessmentId;
        private int? _baselineAssessmentId;

        private readonly int _maturityModelId;

        private List<MATURITY_GROUPINGS> _allGroupings;


        private NestedQuestions _myModel = null;
        public NestedQuestions MyModel { get => _myModel; }


        private const string _currentBarColor = "#007BFF";
        private const string _baselineBarColor = "#cccccc";


        /// <summary>
        /// CTOR
        /// </summary>
        public CisScoringStructure(int assessmentId, CSETContext context)
        {
            this._context = context;
            this._assessmentId = assessmentId;


            // Get the baseline assessment if one is assigned
            var info = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            if (info != null)
            {
                this._baselineAssessmentId = info.Baseline_Assessment_Id;
            }


            var amm = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (amm != null)
            {
                this._maturityModelId = amm.model_id;
            }
            else
            {
                //throw new Exception("CisQuestionsBusiness cannot be instantiated for an assessment without a maturity model.");
            }

            LoadStructure();
        }


        /// <summary>
        /// 
        /// </summary>
        private void LoadStructure()
        {
            _myModel = new NestedQuestions
            {
                AssessmentId = this._assessmentId,
                ModelId = this._maturityModelId
            };

            // Get all subgroupings for this maturity model
            _allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == _maturityModelId).ToList();

            GetSubgroups(MyModel, null);
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        private void GetSubgroups(object oParent, int? parentId)
        {
            var mySubgroups = _allGroupings.Where(x => x.Parent_Id == parentId).OrderBy(x => x.Sequence).ToList();

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var nodeName = System.Text.RegularExpressions
                    .Regex.Replace(sg.Type.Grouping_Type_Name, " ", "_");

                var grouping = new Grouping()
                {
                    GroupType = nodeName,
                    Abbreviation = sg.Abbreviation,
                    GroupingId = sg.Grouping_Id,
                    Prefix = sg.Title_Prefix,
                    Title = sg.Title,
                    Description = sg.Description
                };


                if (oParent is NestedQuestions)
                {
                    ((NestedQuestions)oParent).Groupings.Add(grouping);
                }

                if (oParent is Grouping)
                {
                    ((Grouping)oParent).Groupings.Add(grouping);
                }


                // Score the grouping
                AddScoring(grouping);


                GetSubgroups(grouping, sg.Grouping_Id);
            }
        }


        /// <summary>
        /// Calculate the grouping's scoring and add the chart data to the grouping.
        /// </summary>
        /// <param name="grouping"></param>
        private void AddScoring(Grouping grouping)
        {
            var hChart = new HorizBarChart();
            grouping.Chart = hChart;

            hChart.Labels.Add("");

            var currentScoring = new CisScoring(_assessmentId, grouping.GroupingId, _context);
            var cScore = currentScoring.CalculateGroupingScore();


            var dsCurrentScore = new ChartDataSet();
            dsCurrentScore.Label = "Your Score";
            dsCurrentScore.Type = "bar";
            dsCurrentScore.BackgroundColor.Add(_currentBarColor);
            dsCurrentScore.Data.Add(cScore.GroupingScore);

            hChart.Datasets.Add(dsCurrentScore);

            // include baseline scores, if we have a baseline
            if (_baselineAssessmentId != null)
            {
                var baselineScoring = new CisScoring((int)_baselineAssessmentId, grouping.GroupingId, _context);
                var bScore = baselineScoring.CalculateGroupingScore();

                var dsBaselineScore = new ChartDataSet();
                dsBaselineScore.Label = "Baseline Score";
                dsBaselineScore.Type = "bar";
                dsBaselineScore.BackgroundColor.Add(_baselineBarColor);
                dsBaselineScore.Data.Add(bScore.GroupingScore);
                hChart.Datasets.Add(dsBaselineScore);
            }
        }
    }
}
