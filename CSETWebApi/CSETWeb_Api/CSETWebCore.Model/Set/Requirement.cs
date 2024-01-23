//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class Requirement
    {
        public int RequirementID { get; set; }
        public string SetName { get; set; }
        public string Category { get; set; }
        public string Subcategory { get; set; }
        public int QuestionGroupHeadingID { get; set; }
        public string Title { get; set; }
        public string RequirementText { get; set; }
        public List<string> SalLevels { get; set; } = new List<string>();
        public string SupplementalInfo { get; set; }
        public List<ReferenceDoc> SourceDocs { get; set; } = new List<ReferenceDoc>();
        public List<ReferenceDoc> AdditionalDocs { get; set; } = new List<ReferenceDoc>();
        public List<QuestionDetail> Questions { get; set; } = new List<QuestionDetail>();
    }
}