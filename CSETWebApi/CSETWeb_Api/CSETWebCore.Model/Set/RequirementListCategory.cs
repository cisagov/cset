using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class RequirementListCategory
    {
        public string CategoryName { get; set; }
        public List<RequirementListSubcategory> Subcategories { get; set; } = new List<RequirementListSubcategory>();
    }
}