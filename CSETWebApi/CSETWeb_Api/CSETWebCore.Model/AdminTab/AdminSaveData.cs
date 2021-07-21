namespace CSETWebCore.Model.AdminTab
{
    public class AdminSaveData
    {
        public string Component { get; set; }
        public string ReviewType { get; set; }
        public decimal Hours { get; set; }
        public int? ReviewedCountOverride { get; set; }
        public string OtherSpecifyValue { get; set; }
    }
}