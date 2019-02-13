//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Questions.POCO;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
namespace CSET_Main.Data.ControlData
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


