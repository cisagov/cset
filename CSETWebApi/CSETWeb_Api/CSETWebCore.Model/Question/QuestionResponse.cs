using System.Collections.Generic;
using CSETWebCore.Model.Maturity;

namespace CSETWebCore.Model.Question
{
    public class QuestionResponse
    {
        /// <summary>
        /// Lists the display names of the maturity levels.
        /// </summary>
        public List<MaturityLevel> MaturityLevels;

        // The target level
        public int MaturityTargetLevel;

        public List<Domain> Domains;
        // public List<Category> Categories;

        public string ModelName;

        // The current mode of the assessment
        public string ApplicationMode;

        // The count of all questions in the response.
        public int QuestionCount;

        // The count of all requirements in the response.
        public int RequirementCount;

        // Answer options supported for this question list.  Normally everything 
        // is supported, but maturity models may not offer all options.
        public List<string> AnswerOptions = new List<string>() { "Y", "N", "NA", "A" };



        /// <summary>
        /// The calculated IRP.  If overridden, the override is returned.
        /// </summary>
        public int OverallIRP;

        public int DefaultComponentsCount { get; set; }
    }
}