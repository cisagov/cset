//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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


        public ResultsAnalysisBusiness(CSETContext context, TranslationOverlay overlay, string lang, ITokenManager token)
        {
            _context = context;
            _overlay = overlay;
            _lang = lang;
            _token = token;
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public ChartData ResultsByCategory(int assessmentId)
        {
            ChartData chartData = new ChartData();

            _context.LoadStoredProc("[usp_getStandardsResultsByCategory]")
                    .WithSqlParam("assessment_Id", assessmentId)
                    .ExecuteStoredProc((handler) =>
                    {
                        var result = handler.ReadToList<usp_getStandardsResultsByCategory>();
                        var labels = (from usp_getStandardsResultsByCategory an in result
                                      orderby an.Question_Group_Heading
                                      select new { an.Question_Group_Heading, an.QGH_Id }).Distinct().ToList();




                        // if we are in Requirements mode, sort the group headings into the defined order
                        var _assessmentModeData = new AssessmentModeData(_context, _token);
                        var mode = _assessmentModeData.GetAssessmentMode();

                        if (mode == Enum.StandardModeEnum.Requirement)
                        {
                            //var g = YYYYY(assessmentId);
                        }









                        chartData.DataRows = [];

                        // RKWTODO ------------- SORT BY SEQUENCE BEFORE i18n

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
                                           orderby an.Question_Group_Heading
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


        private void YYYYY(int assessmentId)
        {

            var q = from nr in _context.NEW_REQUIREMENT
                    join rs in _context.REQUIREMENT_SETS on nr.Requirement_Id equals rs.Requirement_Id
                    where rs.Set_Name == "NCSF_V2"
                    orderby rs.Requirement_Sequence
                    select nr.Standard_Category;

            var q1 = q.ToList();


            var q2 = q1.Distinct().ToList();




            
        }
    }
}
