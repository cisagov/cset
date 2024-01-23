//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Xml.Linq;
using CSETWebCore.Model.Charting;
using CSETWebCore.Model.Aggregation;
using System;

namespace CSETWebCore.Business.Aggregation
{
    public class AggregationMaturityBusiness
    {
        private readonly CSETContext _context;


        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="context"></param>
        public AggregationMaturityBusiness(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Returns a collection of maturity models used by the
        /// assessments in the aggregation.  Each model contains
        /// a list of rollup levels (domains, typically) and the
        /// compliance scores (percent Yes) for each assessment
        /// for the rollup.
        /// </summary>
        /// <param name="aggId"></param>
        /// <returns></returns>
        public List<BarChartX> GetMaturityModels(int aggId)
        {
            var chartList = new List<BarChartX>();

            var datasetDict = new Dictionary<string, DatasetX>();

            var modelList = new List<Model>();

            var assessments = _context.AGGREGATION_ASSESSMENT
                .Where(x => x.Aggregation_Id == aggId).ToList();

            foreach (var assessment in assessments)
            {
                var assessmentId = assessment.Assessment_Id;
                var alias = assessment.Alias;

                _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

                var ms = new Helpers.MaturityStructureAsXml(assessmentId, _context, false);
                var mx = ms.ToXDocument();

                // ignore assessment if it doesn't have a maturity model
                if (!mx.Root.HasElements)
                {
                    continue;
                }

                var modelId = int.Parse(mx.Root.Attribute("modelid").Value);
                var modelName = mx.Root.Attribute("model").Value;

                var currentModel = modelList.FirstOrDefault(x => x.ModelId == modelId);
                if (currentModel == null)
                {
                    currentModel = new Model
                    {
                        ModelId = modelId,
                        ModelName = modelName
                    };
                    modelList.Add(currentModel);
                }

                var rand = new Random();

                // one dataset per assessment
                var ds = new DatasetX
                {
                    Label = alias,
                    BackgroundColor = "#777"
                };
                datasetDict.Add($"{modelName} {assessmentId}", ds);


                // get the elements that the compliance calculations occur at
                var rollupElements = GetRollupElements(modelId, mx);

                rollupElements.ForEach(elem =>
                {
                    var title = elem.Attribute("title").Value;

                    var currentRollup = currentModel.Categories.FirstOrDefault(x => x.CategoryTitle == title);

                    if (currentRollup == null)
                    {
                        currentRollup = new RollupLevel();
                        currentRollup.CategoryTitle = title;
                        currentModel.Categories.Add(currentRollup);
                    }

                    // get the relevant questions
                    var questionElements = elem.Descendants("Question").ToList();
                    questionElements = AdjustQuestionsByModel(modelId, questionElements);

                    // calculate percent compliance
                    var yesCount = questionElements.Where(q => q.Attribute("answer").Value == "Y").Count();
                    var totalCount = questionElements.Count;

                    var a = new Assessment
                    {
                        AssessmentId = assessmentId,
                        Alias = alias,
                        RollupScore = 100.0 * (double)yesCount / (double)totalCount
                    };

                    if (!currentModel.AssessmentIds.Contains(assessmentId))
                    {
                        currentModel.AssessmentIds.Add(assessmentId);
                    }

                    currentRollup.Assessments.Add(a);


                    ds.Data.Add(a.RollupScore);
                });
            }

            // Restructure the data into chart.js format

            foreach (var m in modelList)
            {
                var c = new BarChartX();
                chartList.Add(c);

                c.ChartName = m.ModelName;
                c.Labels = m.Categories.Select(x => x.CategoryTitle).ToList();

                // sort assessment datasets by alias
                assessments.OrderBy(x => x.Alias).ToList().ForEach(a =>
                {
                    if (datasetDict.ContainsKey($"{m.ModelName} {a.Assessment_Id}"))
                    {
                        c.Datasets.Add(datasetDict[$"{m.ModelName} {a.Assessment_Id}"]);
                    }
                });
            }

            return chartList;
        }


        /// <summary>
        /// Returns a list of XElement nodes where the calculations rollup to.  
        /// In most maturity models it would be the Domain level.  
        /// But in RRA and CMMC2 there is only a single 'Domain,' so the 
        /// calculation occurs at the Goal level.  EDM rolls up at multiple levels.
        /// </summary>
        private static List<XElement> GetRollupElements(int modelId, XDocument mx)
        {
            // RRA and CMMC2 have a single domain, so rollup at the Goal level
            if (modelId == 5 || modelId == 6)
            {
                return mx.Descendants("Goal").ToList();
            }


            // EDM is unique.  Include MIL-1 Domains plus Goal elements for MIL-2 thru -5.
            if (modelId == 3)
            {
                var list = new List<XElement>();
                list.AddRange(mx.Descendants("Domain").Where(d => d.Attribute("abbreviation").Value != "MIL"));

                var milParent = mx.Descendants("Domain").FirstOrDefault(x => x.Attribute("abbreviation").Value == "MIL");
                list.AddRange(milParent.Descendants("Goal"));
                return list;
            }


            // Most models will rollup at the Domain level
            return mx.Descendants("Domain").ToList();
        }


        /// <summary>
        /// In EDM and CRR, 'parent' questions do not hold answers and should not
        /// be counted when calculating percent compliant.
        /// 
        /// Other model peculiarities can be compensated for here as well.
        /// </summary>
        private static List<XElement> AdjustQuestionsByModel(int modelId, List<XElement> questions)
        {
            // EDM should not consider 'parent' questions
            if (modelId == 3)
            {
                questions.RemoveAll(q => q.Attribute("isparentquestion")?.Value == "true");
            }

            // CRR should not consider 'parent' questions
            if (modelId == 4)
            {
                questions.RemoveAll(q => q.Attribute("isparentquestion")?.Value == "true");
            }

            return questions;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class ModelList
    {
        public List<Model> Models { get; set; }

        public ModelList()
        {
            Models = new List<Model>();
        }
    }

    public class Model
    {
        public string ModelName { get; set; }
        public int ModelId { get; set; }
        public List<int> AssessmentIds { get; set; }
        public List<RollupLevel> Categories { get; set; }

        public Model()
        {
            Categories = new List<RollupLevel>();
            AssessmentIds = new List<int>();
        }
    }

    public class RollupLevel
    {
        public string CategoryTitle { get; set; }
        public List<Assessment> Assessments { get; set; }

        public RollupLevel()
        {
            Assessments = new List<Assessment>();
        }
    }

    public class Assessment
    {
        public int AssessmentId { get; set; }
        public string Alias { get; set; }
        public double RollupScore { get; set; }
    }




}
