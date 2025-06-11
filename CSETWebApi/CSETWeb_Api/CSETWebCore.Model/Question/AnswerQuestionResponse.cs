//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Question
{
    public class AnswerQuestionResponse
    {
        /// <summary>
        /// The key of the ANSWER record that was updated.
        /// </summary>
        public int AnswerId { get; set; }

        /// <summary>
        /// Lets the UI know that question details have changed
        /// so that it can request them to refresh the UI.
        /// </summary>
        public bool DetailsChanged { get; set; }
    }
}
