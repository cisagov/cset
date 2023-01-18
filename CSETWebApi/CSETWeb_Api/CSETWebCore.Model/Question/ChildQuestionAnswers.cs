//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Reports;

namespace CSETWebCore.Model.Question
{
    public class ChildQuestionAnswers
    {
        int questionId;
        int parentQuestionId;
        string questionTitle;
        string questionText;
        string answer;
    }
}