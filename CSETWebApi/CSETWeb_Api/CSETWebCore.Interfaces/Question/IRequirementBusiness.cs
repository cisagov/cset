//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
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
    }
}