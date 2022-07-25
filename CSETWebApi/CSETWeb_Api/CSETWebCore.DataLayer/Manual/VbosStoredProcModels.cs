using System;

namespace CSETWebCore.DataLayer.Manual;


public class VbosStoredProcModels
{
    public class usp_getVbosSummaryOverall
    {
        public int Assessment_Id { get; set; }
        public String Category { get; set; }
        public int Level { get; set; }
        public String Level_Name { get; set; }
        public int? Total { get; set; }
        public double? Percent { get; set; }
    }
}