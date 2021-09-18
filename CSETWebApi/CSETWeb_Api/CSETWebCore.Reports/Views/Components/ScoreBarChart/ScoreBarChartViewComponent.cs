using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using CSETWebCore.Helpers.ReportWidgets;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.Crr;
using Microsoft.AspNetCore.Html;
using CSETWebCore.Model.Maturity;

namespace CSETWebCore.Reports.Views.Components.ScoreBarChart
{
    public class ScoreBarChartViewComponent : ViewComponent
    {
        private CSETContext _context;
        private ICrrScoringHelper _crr;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        public ScoreBarChartViewComponent(CSETContext context, ICrrScoringHelper crr)
        {
            _context = context;
            _crr = crr;
        }


        /// <summary>
        /// Instantiate a ScoreBarChart and populate it with the specified
        /// Domain or Goal's answer counts.
        /// </summary>
        /// <param name="i"></param>
        /// <returns></returns>
        public HtmlString Invoke(BarChartInput i)
        {
            // build the answer color distribution
            _crr.InstantiateScoringHelper(5393);
            AnswerColorDistrib distrib;
            if (string.IsNullOrEmpty(i.GoalAbbrev))
            {
                distrib = _crr.DomainAnswerDistrib(i.DomainAbbrev);
            }
            else
            {
                distrib = _crr.GoalAnswerDistrib(i.DomainAbbrev, i.GoalAbbrev);
            }

            i.AnswerCounts = new List<int>() { 
                distrib.Green,
                distrib.Yellow,
                distrib.Red
            };


            var chart = new Helpers.ReportWidgets.ScoreBarChart(i);
            return new HtmlString(chart.ToString());
        }
    }
}
