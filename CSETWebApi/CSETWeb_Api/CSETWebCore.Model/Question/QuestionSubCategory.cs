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
    public class QuestionSubCategory
    {
        public Guid NavigationGUID { get; set; }
        public int GroupHeadingId { get; set; }
        public int? SubCategoryId { get; set; }
        public string SubCategoryHeadingText { get; set; }
        public string HeaderQuestionText { get; set; }
        public string SubCategoryAnswer { get; set; }
        public List<QuestionAnswer> Questions { get; set; } = new List<QuestionAnswer>();

        public QuestionSubCategory()
        {
            this.NavigationGUID = Guid.NewGuid();
        }
    }
}