//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
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