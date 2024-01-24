//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

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
