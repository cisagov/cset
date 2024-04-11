//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class RequirementListSubcategory
    {
        public string SubcategoryName { get; set; }
        public List<Requirement> Requirements { get; set; } = new List<Requirement>();
    }
}