//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Aggregation
{
    public class MergeAnswer
    {
        public int SourceAnswerID { get; set; }
        public string AnswerText { get; set; }

        public string AlternateJustification { get; set; }

        public string Comment { get; set; }

        public bool MarkedForReview { get; set; }

        public string ComponentGuid { get; set; }



        public MergeAnswer()
        {
            this.SourceAnswerID = 0;
            this.AnswerText = string.Empty;
        }
    }
}