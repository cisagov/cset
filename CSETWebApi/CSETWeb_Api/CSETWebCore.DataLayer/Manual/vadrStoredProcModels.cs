using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.DataLayer.Manual
{
    public class usp_getVADRSummaryOverall
    {
        public int Assessment_Id { get; set; }
        public String Answer_Full_Name { get; set; }
        public string Answer_Text { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }

    public class usp_getVADRSummary
    {
        public int Assessment_Id { get; set; }
        public String Answer_Full_Name { get; set; }
        public String Level_Name { get; set; }
        public string Answer_Text { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }

    public class usp_getVADRSummaryByGoal
    {
        public int Assessment_Id { get; set; }
        public String Answer_Full_Name { get; set; }
        public String Title { get; set; }
        public string Answer_Text { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }

    public class usp_getVADRSummaryByGoalOverall
    {
        public int Assessment_Id { get; set; }
        public string Title { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }
}