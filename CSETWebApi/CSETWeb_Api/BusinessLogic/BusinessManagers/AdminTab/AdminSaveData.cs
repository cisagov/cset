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
}