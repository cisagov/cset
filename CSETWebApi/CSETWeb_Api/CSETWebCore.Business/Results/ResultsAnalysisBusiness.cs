//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Aggregation;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Model.Analysis;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Standards;
using Microsoft.Extensions.Configuration;
using Snickler.EFCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Results
{
    public class ResultsAnalysisBusiness
    {
        private CSETContext _context;

        private TranslationOverlay _overlay;
        private string _lang;
        private ITokenManager _token;


        /// <summary>
        /// Constructs an instance of ResultsAnalysisBusiness.
        /// </summary>
        public ResultsAnalysisBusiness(CSETContext context, TranslationOverlay overlay, string lang, ITokenManager token)
        {
            _context = context;
            _overlay = overlay;
            _lang = lang;
            _token = token;
        }


        /// <summary>
        /// Returns chart results for the "Results By CategorY" page.
        /// </summary>
        /// <returns></returns>
        public ChartData ResultsByCategory(int assessmentId)
        {
            ChartData chartData = new();

            _context.LoadStoredProc("[usp_getStandardsResultsByCategory]")
                    .WithSqlParam("assessment_Id", assessmentId)
                    .ExecuteStoredProc((handler) =>
                    {
                        // begin with alpha-sorted group headings
                        var result = handler.ReadToList<usp_getStandardsResultsByCategory>().OrderBy(x => x.Question_Group_Heading).ToList();
                        var labels = (from usp_getStandardsResultsByCategory an in result
                                      orderby an.Question_Group_Heading
                                      select new QuestionGroupHeadingSimple(an.Question_Group_Heading, an.QGH_Id)).Distinct().ToList();



                        // if we are in Requirements mode, sort the group headings into the standard's defined category order
                        var _assessmentModeData = new AssessmentModeData(_context, _token);
                        var mode = _assessmentModeData.GetAssessmentMode();

                        if (mode == Enum.StandardModeEnum.Requirement)
                        {
                            OrderCategoriesBySequence(assessmentId, ref result, ref labels);
                        }


                        chartData.DataRows = [];

                        foreach (var c in labels)
                        {
                            chartData.Labels.Add(_overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), _lang)?.Value ??
                                c.Question_Group_Heading);
                        }

                        ColorsList colors = new ColorsList();

                        var sets = (from usp_getStandardsResultsByCategory an in result
                                    select new { an.Set_Name, an.Short_Name }).Distinct();

                        foreach (var set in sets)
                        {
                            ChartData nextChartData = new ChartData();
                            chartData.dataSets.Add(nextChartData);
                            nextChartData.DataRows = [];

                            var nextSet = (from usp_getStandardsResultsByCategory an in result
                                           where an.Set_Name == set.Set_Name
                                           select an).ToList();

                            nextChartData.label = set.Short_Name;
                            nextChartData.backgroundColor = colors.getNext(set.Set_Name);

                            foreach (usp_getStandardsResultsByCategory c in nextSet)
                            {
                                nextChartData.data.Add((double)c.prc);
                                nextChartData.Labels.Add(_overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), _lang)?.Value ?? c.Question_Group_Heading);
                                nextChartData.DataRows.Add(new DataRows()
                                {
                                    failed = c.yaCount,
                                    percent = c.prc,
                                    total = c.Actualcr,
                                    title = _overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), _lang)?.Value ?? c.Question_Group_Heading
                                });
                            }
                        }
                    });

            return chartData;
        }


        /// <summary>
        /// Orders the labels and results collections by the sequence defined
        /// by the Requirement_Sequence property of its requirements.
        /// </summary>
        private void OrderCategoriesBySequence(int assessmentId, ref List<usp_getStandardsResultsByCategory> result, ref List<QuestionGroupHeadingSimple> labels)
        {
            var newResult = new List<usp_getStandardsResultsByCategory>();
            var newLabels = new List<QuestionGroupHeadingSimple>();

            var setNames = result.Select(x => x.Set_Name).Distinct().ToList();

            foreach (var setName in setNames)
            {
                var q = from nr in _context.NEW_REQUIREMENT
                        join rs in _context.REQUIREMENT_SETS on nr.Requirement_Id equals rs.Requirement_Id
                        where rs.Set_Name == setName
                        orderby rs.Requirement_Sequence
                        select nr.Standard_Category;

                var orderedBySequence = q.ToList().Distinct().ToList();

                foreach (var item in orderedBySequence)
                {
                    var r = result.Where(x => x.Question_Group_Heading == item).FirstOrDefault();
                    var l = labels.Where(x => x.Question_Group_Heading == item).FirstOrDefault();

                    if (r != null || l != null)
                    {
                        newResult.Add(r);
                        newLabels.Add(l);
                    }
                }
            }

            result = newResult;
            labels = newLabels;
        }
    }
}
