//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.Question
{
    public class BaseQuestionInfoData
    {
        public SETS Set { get; set; }
        public int QuestionID { get; set; }
        public NEW_QUESTION Question { get; set; }
        public NEW_REQUIREMENT Requirement { get; set; }
        public MATURITY_QUESTIONS MaturityQuestion { get; set; }
    }
}