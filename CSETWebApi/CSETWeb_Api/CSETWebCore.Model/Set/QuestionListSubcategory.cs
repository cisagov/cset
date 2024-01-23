//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class QuestionListSubcategory
    {
        public int PairID;
        public string SubcategoryName;
        public string SubHeading;

        /// <summary>
        /// Only subheadings on custom question pairs are editable.
        /// </summary>
        public bool IsSubHeadingEditable;
        public List<QuestionDetail> Questions = new List<QuestionDetail>();
    }
}