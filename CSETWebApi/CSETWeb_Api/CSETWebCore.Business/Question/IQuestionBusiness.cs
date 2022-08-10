using System.Collections.Generic;
using System.Threading.Tasks;
using CSETWebCore.Model.Question;


namespace CSETWebCore.Business.Question
{
    public interface IQuestionBusiness
    {
        void SetQuestionAssessmentId(int assessmentId);
        QuestionResponse GetQuestionListWithSet(string questionGroupName);
        Task<QuestionResponse> GetQuestionList(string questionGroupName);
        List<AnalyticsQuestionAnswer> GetAnalyticQuestionAnswers(QuestionResponse questionResponse);
        Task<List<int>> GetActiveAnswerIds();
        Task<QuestionDetails> GetDetails(int questionId, string questionType);
        QuestionResponse BuildResponse();
        Task StoreSubcategoryAnswers(SubCategoryAnswers subCatAnswerBlock);
    }
}