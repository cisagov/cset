namespace CSETWebCore.Model.Sal
{
    public class Sals
    {
        public string Selected_Sal_Level { get; set; }
        public string Last_Sal_Determination_Type { get; set; }
        public string Sort_Set_Name { get; set; }
        public string CLevel { get; set; }
        public string ILevel { get; set; }
        public string ALevel { get; set; }
        public bool SelectedSALOverride { get; set; }
        public string AssessmentName { get; internal set; }
    }
}
