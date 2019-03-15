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
        public int DocumentationTotal { get; set; }
        public int InterviewTotal { get; set; }
        public int GrandTotal { get; set; }
        public int ReviewedTotal { get; set; }
    }
}