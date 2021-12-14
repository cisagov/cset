using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class Requirement
    {
        public int RequirementID;
        public string SetName;
        public string Category;
        public string Subcategory;
        public int QuestionGroupHeadingID;
        public string Title;
        public string RequirementText;
        public List<string> SalLevels = new List<string>();
        public string SupplementalInfo;
        public List<ReferenceDoc> SourceDocs = new List<ReferenceDoc>();
        public List<ReferenceDoc> ResourceDocs = new List<ReferenceDoc>();
        public List<QuestionDetail> Questions = new List<QuestionDetail>();
    }
}