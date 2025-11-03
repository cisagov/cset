using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class MissedQuestionResponse
    {
        // The answer values that are considered "missed"
        public List<string> BadAnswers { get; set; } = new List<string>();

        public List<MissedQuestion> MissedQuestions { get; set; } = new List<MissedQuestion>();
    }
}
