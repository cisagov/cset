//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Helpers.ReportWidgets
{
    public class BarChartInput
    {
        public int Width { get; set; }
        public int Height { get; set; }

        public int Gap { get; set; }

        public List<int> AnswerCounts { get; set; }

        public List<string> BarColors { get; set; }

        public bool IncludePercentFirstBar = false;

        public string DomainAbbrev { get; set; }

        public string GoalAbbrev { get; set; }

        public bool ShowNA { get; set; } = false;

        public bool HideEmptyChart { get; set; } = false;



        /// <summary>
        /// Initialize the input object with some default values.
        /// </summary>
        public BarChartInput()
        {
            // set some default properties that will hopefully get overridden
            this.Height = 300;
            this.Width = 400;
            this.Gap = 5;
            this.AnswerCounts = new List<int>() { 0, 0, 0 };
            this.BarColors = new List<string>() { "green", "yellow", "red" };
        }
    }
}
