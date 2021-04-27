using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class QuestionGroup
    {
        public bool IsOverride;
        public Guid NavigationGUID;
        public int GroupHeadingId;
        public string GroupHeadingText;
        public string StandardShortName;
        public string ComponentName;
        public string SetName;
        public List<QuestionSubCategory> SubCategories = new List<QuestionSubCategory>();

        public string Symbol_Name { get; set; }
        public QuestionGroup()
        {
            this.NavigationGUID = Guid.NewGuid();
            this.IsOverride = false;
        }
    }
}