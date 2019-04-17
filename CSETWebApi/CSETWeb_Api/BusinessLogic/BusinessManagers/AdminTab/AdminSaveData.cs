using System;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.AdminTab
{
    public class AdminSaveData
    {
        public string Component { get; set; }
        public string ReviewType { get; set; }
        public decimal Hours { get; set; }
        public Nullable<int> ReviewedCountOverride { get; set; }
        public string OtherSpecifyValue { get; set; }
    }

    public class AdminSaveResponse
    {
        public double DocumentationTotal { get; set; }
        public double InterviewTotal { get; set; }
        public double GrandTotal { get; set; }
        public double ReviewedTotal { get; set; }
    }
}