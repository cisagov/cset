using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class RequirementListCategory
    {
        public string CategoryName;
        public List<RequirementListSubcategory> Subcategories = new List<RequirementListSubcategory>();
    }
}