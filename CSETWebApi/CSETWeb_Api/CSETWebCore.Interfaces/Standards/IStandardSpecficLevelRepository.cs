using System.Collections.Generic;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Interfaces.Standards
{
    public interface IStandardSpecficLevelRepository
    {
        int GetLevelOrder(string standardLevel);
        string GetFullName(string standard, int levelOrder);
        string GetStandard(string standard_level);

        string GetFullToShort_Name(string fullName);
        RequirementLevel GetRequirementLevel(List<REQUIREMENT_LEVELS> listRequirementLevels);
        int GetQuestionMinLevelOrder(IEnumerable<NEW_QUESTION_LEVELS> questionLevels);
    }
}