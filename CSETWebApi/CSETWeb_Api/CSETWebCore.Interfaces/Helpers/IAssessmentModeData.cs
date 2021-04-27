using CSETWebCore.Enum;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IAssessmentModeData
    {
        StandardModeEnum GetAssessmentMode();
        void SaveMode(StandardModeEnum standardMode);
        void SaveSortSet(string set);
        string GetSortSet();
        string DetermineDefaultApplicationMode();
        string DetermineDefaultApplicationModeAbbrev();
    }
}