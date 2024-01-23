//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class MergeQuestion
    {
        public int QuestionID { get; set; }
        public string QuestionText { get; set; }
        public int CombinedAnswerID { get; set; }
        public List<MergeAnswer> SourceAnswers = new List<MergeAnswer>();
        public string DefaultAnswer { get; set; }
        public int CategoryID { get; set; }
        public string CategoryText { get; set; }
        public bool Is_Component { get; set; }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="abc"></param>
        public MergeQuestion(int abc)
        {
            for (int i = 0; i < abc; i++)
            {
                this.SourceAnswers.Add(new MergeAnswer());
            }
        }
    }
}