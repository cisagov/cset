//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class AddQuestionsRequest
    {
        /// <summary>
        /// SetName is specified when the question is attached to the set
        /// </summary>
        public string SetName;

        /// <summary>
        /// RequirementID is specified when the question is attached to a requirement.
        /// </summary>
        public int RequirementID;

        /// <summary>
        /// A list of question and SAL for connecting questions to sets and requirements.
        /// </summary>
        public List<QuestionAdd> QuestionList;
    }
}