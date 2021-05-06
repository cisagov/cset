using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class SubCategoryAnswers
    {
        /// <summary>
        /// 
        /// </summary>
        public int GroupHeadingId;

        /// <summary>
        /// 
        /// </summary>
        public int SubCategoryId;

        /// <summary>
        /// The answer stored in the SUB_CATEGORY_ANSWERS table.
        /// </summary>
        public string SubCategoryAnswer;

        /// <summary>
        /// The collection of answers to the questions in the subcategory
        /// </summary>
        public List<Answer> Answers;
    }
}