//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class SetQuestion
    {
        /// <summary>
        /// SetName is specified when the question is attached to the set
        /// </summary>
        public string SetName;

        /// <summary>
        /// RequirementID is specified when the question is attached to a requirement.
        /// </summary>
        public int RequirementID;

        public int QuestionID;
        public int QuestionCategoryID;

        /// <summary>
        /// The name of a new subcategory.  Only used when the user has invented 
        /// a new subcategory name.
        /// </summary>
        public string QuestionSubcategoryText;

        /// <summary>
        /// Used when creating a new question from text.
        /// </summary>
        public string CustomQuestionText;

        public List<string> SalLevels;
    }
}