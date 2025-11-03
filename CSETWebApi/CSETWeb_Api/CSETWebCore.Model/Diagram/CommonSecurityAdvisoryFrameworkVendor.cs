//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Diagram
{
    public class CommonSecurityAdvisoryFrameworkVendor
    {
        public CommonSecurityAdvisoryFrameworkVendor() { }

        public CommonSecurityAdvisoryFrameworkVendor(CommonSecurityAdvisoryFrameworkObject csafObj)
        {
            Name = csafObj.Product_Tree.Branches[0].Name;
            Products = new List<CommonSecurityAdvisoryFrameworkProduct>();
        }

        public string Name { get; set; }
        public List<CommonSecurityAdvisoryFrameworkProduct> Products { get; set; }
    }
}
