//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Question
{
    public class FrameworkInfoData
    {
        public int RequirementID { get; set; }
        public bool IsCustomQuestion { get; set; }
        public string References { get; set; }
        public string Question { get; set; }
        public string SupplementalInfo { get; set; }
        public string SetName { get; set; }
        public string Category { get; set; }
        public string Title { get; set; }
    }
}