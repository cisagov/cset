//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Sal
{
    public class NistQuestionPoco
    {
        public int Question_Id { get; set; }
        public String Simple_Question { get; set; }

        private string answerText;
        public string Question_Answer
        {
            get { return answerText; }
            set
            {
                answerText = value;
            }
        }

        public int QuestionNumber { get; set; }


        public bool IsAnswerYes
        {
            get
            {
                if ((Question_Answer == Constants.Constants.YES) || (Question_Answer.Equals(Constants.Constants.YESFull, StringComparison.CurrentCultureIgnoreCase)))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
    }
}

