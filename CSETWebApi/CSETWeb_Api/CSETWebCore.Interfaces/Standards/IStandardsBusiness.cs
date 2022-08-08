using System.Collections.Generic;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Standards;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Standards
{
    public interface IStandardsBusiness
    {
        StandardsResponse GetStandards(int assessmentId);
        bool GetFramework(int assessmentId);
        bool GetACET(int assessmentId);
        List<string> RecommendedStandards(int assessmentId);
        Task<QuestionRequirementCounts> PersistSelectedStandards(int assessmentId, List<string> selectedStandards);
        Task<QuestionRequirementCounts> PersistDefaultSelectedStandard(int assessmentId);
        List<string> GetDefaultStandardsList();
    }
}