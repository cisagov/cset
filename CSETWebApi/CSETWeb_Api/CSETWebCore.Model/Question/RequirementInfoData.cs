using System.Collections.Generic;
using DataLayerCore.Model;

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