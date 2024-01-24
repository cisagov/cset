//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.Question
{
    public class RequirementInfoData
    {
        public int RequirementID { get; set; }
        public string SetName { get; set; }
        public string Category { get; set; }
        public NEW_REQUIREMENT Requirement { get; set; }
        public Dictionary<string, SETS> Sets { get; set; }
    }
}