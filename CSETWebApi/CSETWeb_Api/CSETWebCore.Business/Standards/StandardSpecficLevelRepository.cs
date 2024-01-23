//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Business.Standards
{
    public class StandardSpecficLevelRepository : IStandardSpecficLevelRepository
    {
        private Dictionary<string, Dictionary<int, String>> standardLevelLookup = new Dictionary<String, Dictionary<int, String>>();
        private Dictionary<string, string> StandardLevelToStandard = new Dictionary<string, string>();
        private Dictionary<string, int> StandardLevelToLevelOrder = new Dictionary<string, int>();
        private Dictionary<string, string> fullNameToStandardLevel = new Dictionary<string, string>();
        private int maxLevel;

        private CSETContext Context { get; }

        public StandardSpecficLevelRepository(CSETContext context)
        {
            this.Context = context;
            SetStandardLevelLookup();

        }

        private void SetStandardLevelLookup()
        {
            standardLevelLookup = new Dictionary<String, Dictionary<int, String>>();
            var Standard_Levels = Context.STANDARD_SPECIFIC_LEVEL.ToList();
            maxLevel = 0;
            foreach (STANDARD_SPECIFIC_LEVEL s in Standard_Levels)
            {
                if (standardLevelLookup.ContainsKey(s.Standard))
                {
                    standardLevelLookup[s.Standard].Add(s.Level_Order, s.Full_Name);
                }
                else
                {
                    standardLevelLookup.Add(s.Standard, new Dictionary<int, String>());
                    standardLevelLookup[s.Standard].Add(s.Level_Order, s.Full_Name);
                }
                StandardLevelToStandard.Add(s.Standard_Level, s.Standard);
                StandardLevelToLevelOrder.Add(s.Standard_Level, s.Level_Order);

                if (maxLevel < s.Level_Order)
                    maxLevel = s.Level_Order;

                fullNameToStandardLevel.Add(s.Full_Name, s.Standard_Level);
            }

        }




        public String GetFullToShort_Name(string fullName)
        {
            return fullNameToStandardLevel[fullName];
        }


        public int GetRequirementMinLevelOrder(IEnumerable<REQUIREMENT_LEVELS> requirementLevels)
        {
            return requirementLevels.Select(t => GetLevelOrder(t.Standard_Level)).DefaultIfEmpty(0).Min();
        }

        public int GetQuestionMinLevelOrder(IEnumerable<NEW_QUESTION_LEVELS> questionLevels)
        {
            return questionLevels.Select(t => GetLevelOrder(t.Universal_Sal_Level)).DefaultIfEmpty(0).Min();
        }

        public int GetLevelOrder(string standardLevel)
        {
            return StandardLevelToLevelOrder[standardLevel];
        }

        public string GetStandard(string standard_level)
        {
            return StandardLevelToStandard[standard_level];
        }

        public string GetFullName(string standard, int levelOrder)
        {
            return standardLevelLookup[standard][levelOrder];
        }

        public RequirementLevel GetRequirementLevel(List<REQUIREMENT_LEVELS> listRequirementLevels)
        {
            REQUIREMENT_LEVELS level = listRequirementLevels[0];
            int sallevels = GetRequirementMinLevelOrder(listRequirementLevels);
            string requirement_SAL_Type = GetStandard(level.Standard_Level);
            String requirement_sal_level = GetFullName(requirement_SAL_Type, sallevels);
            RequirementLevel requirementLevel = new RequirementLevel() { LevelOrder = sallevels, StandardLevel = requirement_sal_level };
            return requirementLevel;
        }
    }
}