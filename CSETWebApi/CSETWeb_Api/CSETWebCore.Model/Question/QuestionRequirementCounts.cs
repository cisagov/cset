namespace CSETWebCore.Model.Question
{
    public class QuestionRequirementCounts
    {
        /// <summary>
        /// The number of active Questions based on the selected Standards.
        /// </summary>
        public int QuestionCount { get; set; }

        /// <summary>
        /// The number of active Requirements based on the selected Standards.
        /// </summary>
        public int RequirementCount { get; set; }
    }
}