using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.DataLayer.Manual
{
    public class usp_getRRASummaryOverall
    {
        public int Assessment_Id { get; set; }
        public String Answer_Full_Name { get; set; }
        public string Answer_Text { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }

    public class usp_getRRASummary
    {
        public int Assessment_Id { get; set; }
        public String Answer_Full_Name { get; set; }
        public String Level_Name { get; set; }
        public string Answer_Text { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }

    public class usp_getRRASummaryByGoal
    {
        public int Assessment_Id { get; set; }
        public String Answer_Full_Name { get; set; }
        public String Title { get; set; }
        public int Grouping_Id { get; set; }
        public string Answer_Text { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }

    public class usp_getRRASummaryByGoalOverall
    {
        public int Assessment_Id { get; set; }
        public string Title { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }
}
