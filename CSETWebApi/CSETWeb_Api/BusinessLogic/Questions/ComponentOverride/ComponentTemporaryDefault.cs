//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Questions.POCO;
using DataLayer;
using System;

namespace CSET_Main.Questions.ComponentOverride
{
    public class ComponentTemporaryDefault 
    {
        private bool isAnswerYes;
        public bool IsAnswerYes
        {

            get
            {
                return QuestionAnswer == AnswerEnum.YES;
            }
            set
            {
                isAnswerYes = value;
                
            }
        }

        private bool isAnswerNo;
        public bool IsAnswerNo
        {

            get
            {
                return QuestionAnswer == AnswerEnum.NO;
            }
            set
            {
                isAnswerNo = value;
                
            }
        }

        private bool isAnswerNa;
        public bool IsAnswerNa
        {
            get
            {
                return QuestionAnswer == AnswerEnum.NA;
            }
            set
            {
                isAnswerNa = value;
                
            }
        }

        private bool isAnswerAlt;
        public bool IsAnswerAlt
        {
            get
            {
                return QuestionAnswer == AnswerEnum.ALT;
            }
            set
            {
                isAnswerAlt = value;
                
            }
        }

        private AnswerEnum questionAnswer;
        public AnswerEnum QuestionAnswer
        {
            get { return questionAnswer; }
            set { questionAnswer = value;  }
        }      

        private QuestionPoco _OriginalPoco = null;
        public QuestionPoco OriginalPoco
        {
            get { return _OriginalPoco; }
            set
            {            
                _OriginalPoco = value;
                
            }
        }

        public string ComponentName { get; set; }

        public Guid GUID { get; set; }


        //public NetworkComponent Component { get; set; }
        //public String ComponentSal { get { return Component.SAL.Selected_Sal_Level; } }

    
        

        public ComponentTemporaryDefault()
        {            
        
        }

        public void SetAnswerOnQuestionPoco()
        {   
            this.OriginalPoco.SetAnswer(QuestionAnswer);
        }



        internal void SetAnswer(AnswerEnum answer)
        {
            QuestionAnswer = answer;            
        }
    }
}


