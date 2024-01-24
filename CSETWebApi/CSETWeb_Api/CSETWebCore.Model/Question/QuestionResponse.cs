//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Maturity;

namespace CSETWebCore.Model.Question
{
    public class QuestionResponse
    {
        /// <summary>
        /// Lists the display names of the maturity levels.
        /// </summary>
        public List<MaturityLevel> MaturityLevels { get; set; }

        // The target level
        //public int MaturityTargetLevel { get; set; }

        public List<QuestionGroup> Categories { get; set; }

        // public string ModelName { get; set; }

        // The current mode of the assessment
        public string ApplicationMode { get; set; }

        // Indicates if only the current mode should be available.
        // (e.g. if 'requirements only', the Questions Mode toggle would not display)
        public bool OnlyMode { get; set; }

        // The count of all questions in the response.
        public int QuestionCount { get; set; }

        // The count of all requirements in the response.
        public int RequirementCount { get; set; }

        // Answer options supported for this question list.  Normally everything 
        // is supported, but maturity models may not offer all options.
        public List<string> AnswerOptions { get; set; } = new List<string>() { "Y", "N", "NA", "A" };



        /// <summary>
        /// The calculated IRP.  If overridden, the override is returned.
        /// </summary>
        public int OverallIRP { get; set; }

        public int DefaultComponentsCount { get; set; }



        /// <summary>
        /// Constructor
        /// </summary>
        public QuestionResponse()
        {
            this.Categories = new List<QuestionGroup>();
        }
    }
}