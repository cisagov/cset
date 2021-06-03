using System.Collections.Generic;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Interfaces.Question
{
    public interface IRequirementBusiness
    {
        void SetRequirementAssessmentId(int assessmentId);
        QuestionResponse GetRequirementsList();
        RequirementsPass GetControls();

        QuestionResponse BuildResponse(List<RequirementPlus> requirements,
            List<FullAnswer> answers, List<DomainAssessmentFactor> domains);

        CategoryContainer BuildDomainResponse(DomainAssessmentFactor domain);
        QuestionGroup BuildCategoryResponse();
        QuestionSubCategory BuildSubcategoryResponse();
        QuestionResponse BuildResponseOLD(List<RequirementPlus> requirements,
            List<FullAnswer> answers, List<DomainAssessmentFactor> domains);
        List<int> GetActiveAnswerIds();
        void LoadParametersList();
        public List<ParameterToken> GetTokensForRequirement(int reqId, int ansId);
        List<ParameterToken> GetDefaultParametersForAssessment();
        ParameterToken SaveAssessmentParameter(int parameterId, string newText);
        ParameterToken SaveAnswerParameter(int requirementId, int parameterId, int answerId, string newText);
        string ResolveParameters(int reqId, int ansId, string requirementText);
        string RichTextParameters(int reqId, int ansId, string requirementText);
    }
}