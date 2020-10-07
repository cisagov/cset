//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;

namespace CSET_Main.SALS
{
    public class NISTQuestionPoco 
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
                if ((Question_Answer == Constants.YES)||(Question_Answer.Equals(Constants.YESFull,StringComparison.CurrentCultureIgnoreCase)))
                {
                    return true;
                }
                else
                    return false;
            } 
        }

    }
}


