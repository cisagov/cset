using System;

namespace CSETWebCore.DataLayer.Manual;


public class CrmpStoredProcModels
{
    public class usp_getCrmpSummary
    {
        public int Assessment_Id { get; set; }
        public String Answer_Full_Name { get; set; }
        public String Level_Name { get; set; }
        public string Answer_Text { get; set; }
        public int? qc { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }
}