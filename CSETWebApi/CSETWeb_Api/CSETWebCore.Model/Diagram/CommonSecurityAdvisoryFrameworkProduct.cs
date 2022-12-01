using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Diagram
{
    public class CommonSecurityAdvisoryFrameworkProduct
    {
        public CommonSecurityAdvisoryFrameworkProduct() { }

        public CommonSecurityAdvisoryFrameworkProduct(CommonSecurityAdvisoryFrameworkObject csafObj) 
        { 
            Name = csafObj.Product_Tree.Branches[0].Branches[0].Name;
            Vulnerabilities = csafObj.Vulnerabilities;
            Versions = new List<Version>();

            foreach (var branch in csafObj.Product_Tree.Branches[0].Branches) 
            {
                Versions.Add(new Version(branch.Branches[0].Name, branch.Branches[0].Product.Product_Id));
            }
        }

        public string Name { get; set; }
        public List<CommonSecurityAdvisoryFrameworkObject.Vulnerability> Vulnerabilities { get; set; }
        public List<Version> Versions { get; set; }

        public class Version 
        {
            public Version(string name, string productId) 
            {
                Name = name;
                Product_Id = productId;
            }

            public string Name { get; set; }
            public string Product_Id { get; set; }
        }
    }
}
