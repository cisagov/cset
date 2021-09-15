using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Helpers;
using CSETWebCore.Helpers.ReportWidgets;
using CSETWebCore.DataLayer;
using Microsoft.AspNetCore.Html;
using CSETWebCore.Model.Maturity;

namespace CSETWebCore.Reports.Views.Components.ScoreBarChart
{
    public class ScoreBarChartViewComponent : ViewComponent
    {
        private CSETContext _context;
        private CrrScoringHelper _csh;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        public ScoreBarChartViewComponent(CSETContext context)
        {
            _context = context;

            // TODO:  This should eventually get injected from a service--------
            _csh = new CrrScoringHelper(_context, 4622);
            // -----------------------------------------------------------------
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
            AnswerColorDistrib distrib;
            if (string.IsNullOrEmpty(i.GoalAbbrev))
            {
                distrib = _csh.DomainAnswerDistrib(i.DomainAbbrev);
            }
            else
            {
                distrib = _csh.GoalAnswerDistrib(i.DomainAbbrev, i.GoalAbbrev);
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
