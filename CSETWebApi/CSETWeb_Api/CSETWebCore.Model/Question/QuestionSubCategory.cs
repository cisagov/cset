using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class QuestionSubCategory
    {
        public Guid NavigationGUID;
        public int GroupHeadingId;
        public int SubCategoryId;
        public string SubCategoryHeadingText;
        public string HeaderQuestionText;
        public string SubCategoryAnswer;
        public List<QuestionAnswer> Questions = new List<QuestionAnswer>();

        public QuestionSubCategory()
        {
            this.NavigationGUID = Guid.NewGuid();
        }
    }
}