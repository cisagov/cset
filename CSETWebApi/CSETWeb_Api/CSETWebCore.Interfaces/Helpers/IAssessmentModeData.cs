using CSETWebCore.Enum;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IAssessmentModeData
    {
        bool IsRequirement { get; }
        bool IsQuestion { get; }
        bool IsFramework { get; }
        Task<StandardModeEnum> GetAssessmentMode();
        Task SaveMode(StandardModeEnum standardMode);
        Task SaveSortSet(string set);
        Task<string> GetSortSet();
        string DetermineDefaultApplicationMode();
        string DetermineDefaultApplicationModeAbbrev();
    }
}