using System.Collections.Generic;
using CSETWebCore.Model.Question;


namespace CSETWebCore.Interfaces.Question
{
    public interface IQuestionBusiness
    {
        void SetQuestionAssessmentId(int assessmentId);
        QuestionResponse GetQuestionListWithSet(string questionGroupName);
        QuestionResponse GetQuestionList(string questionGroupName);
        List<AnalyticsQuestionAnswer> GetAnalyticQuestionAnswers(QuestionResponse questionResponse);
        List<int> GetActiveAnswerIds();
        QuestionDetailsContentViewModel GetDetails(int questionId, bool IsComponent, bool IsMaturity);
        QuestionResponse BuildResponse();
        void StoreSubcategoryAnswers(SubCategoryAnswers subCatAnswerBlock);
    }
}