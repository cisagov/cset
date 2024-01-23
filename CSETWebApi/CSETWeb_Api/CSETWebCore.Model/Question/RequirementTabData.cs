//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Question
{
    public class RequirementTabData
    {
        public int RequirementID { get; set; }
        public string Text { get; set; }
        public string SupplementalInfo { get; set; }
        public string SupplementalFact { get; set; }
        public string ExaminationApproach { get; set; }

        public string Set_Name { get; set; }
    }
}