using System.Collections.Generic;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Interfaces.Question
{
    public interface IRequirementBusiness
    {
        void SetRequirementAssessmentId(int assessmentId);
        Task<QuestionResponse> GetRequirementsList();
        Task<RequirementsPass> GetControls();

        QuestionResponse BuildResponse(List<RequirementPlus> requirements,
            List<FullAnswer> answers, List<DomainAssessmentFactor> domains);

        CategoryContainer BuildDomainResponse(DomainAssessmentFactor domain);
        QuestionGroup BuildCategoryResponse();
        QuestionSubCategory BuildSubcategoryResponse();
        QuestionResponse BuildResponseOLD(List<RequirementPlus> requirements,
            List<FullAnswer> answers, List<DomainAssessmentFactor> domains);
        Task<List<int>> GetActiveAnswerIds();
        Task LoadParametersList();
        public List<ParameterToken> GetTokensForRequirement(int reqId, int ansId);
        Task<List<ParameterToken>> GetDefaultParametersForAssessment();
        Task<ParameterToken> SaveAssessmentParameter(int parameterId, string newText);
        Task<ParameterToken> SaveAnswerParameter(int requirementId, int parameterId, int answerId, string newText);
        string ResolveParameters(int reqId, int ansId, string requirementText);
        string RichTextParameters(int reqId, int ansId, string requirementText);
    }
}