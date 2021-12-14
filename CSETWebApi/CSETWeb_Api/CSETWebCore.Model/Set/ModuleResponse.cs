using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class ModuleResponse
    {
        public string SetFullName;
        public string SetShortName;
        public string SetDescription;
        public List<RequirementListCategory> Categories = new List<RequirementListCategory>();
    }
}