//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Enum;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IAssessmentModeData
    {
        bool IsRequirement { get; }
        bool IsQuestion { get; }
        bool IsFramework { get; }
        StandardModeEnum GetAssessmentMode();
        void SaveMode(StandardModeEnum standardMode);
        void SaveSortSet(string set);
        string GetSortSet();
        string DetermineDefaultApplicationMode();
        string DetermineDefaultApplicationModeAbbrev();
    }
}