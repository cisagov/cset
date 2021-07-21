using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class QuestionListCategory
    {
        public string CategoryName;
        public List<QuestionListSubcategory> Subcategories = new List<QuestionListSubcategory>();
    }
}