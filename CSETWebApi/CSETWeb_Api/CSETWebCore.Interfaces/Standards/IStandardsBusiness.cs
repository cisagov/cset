//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Standards;

namespace CSETWebCore.Interfaces.Standards
{
    public interface IStandardsBusiness
    {
        StandardsResponse GetStandards(int assessmentId);
        bool GetFramework(int assessmentId);
        bool GetACET(int assessmentId);
        List<string> RecommendedStandards(int assessmentId);
        QuestionRequirementCounts PersistSelectedStandards(int assessmentId, List<string> selectedStandards);
        QuestionRequirementCounts PersistDefaultSelectedStandard(int assessmentId);
        List<string> GetDefaultStandardsList();
    }
}