//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class QuestionGroup
    {
        public bool IsOverride { get; set; }
        public Guid NavigationGUID { get; set; }
        public int GroupHeadingId { get; set; }
        public string GroupHeadingText { get; set; }
        public string StandardShortName { get; set; }
        public string ComponentName { get; set; }
        public string SetName { get; set; }
        public List<QuestionSubCategory> SubCategories { get; set; } = new List<QuestionSubCategory>();

        public string Symbol_Name { get; set; }

        public QuestionGroup()
        {
            this.NavigationGUID = Guid.NewGuid();
            this.IsOverride = false;
        }
    }
}