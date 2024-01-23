//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class ModuleResponse
    {
        public string SetFullName { get; set; }
        public string SetShortName { get; set; }
        public string SetDescription { get; set; }
        public List<RequirementListCategory> Categories { get; set; } = new List<RequirementListCategory>();
    }
}