//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class SubCategoryAnswers
    {
        /// <summary>
        /// 
        /// </summary>
        public int GroupHeadingId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public int SubCategoryId { get; set; }

        /// <summary>
        /// The answer stored in the SUB_CATEGORY_ANSWERS table.
        /// </summary>
        public string SubCategoryAnswer { get; set; }

        /// <summary>
        /// The collection of answers to the questions in the subcategory
        /// </summary>
        public List<Answer> Answers { get; set; }
    }
}