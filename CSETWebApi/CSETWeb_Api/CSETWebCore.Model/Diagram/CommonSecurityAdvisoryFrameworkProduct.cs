//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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

        public CommonSecurityAdvisoryFrameworkProduct(CommonSecurityAdvisoryFrameworkObject csafObj, CommonSecurityAdvisoryFrameworkObject.Branch branch)
        {
            Name = branch.Name;
            Vulnerabilities = new List<CommonSecurityAdvisoryFrameworkObject.Vulnerability>();
            AffectedVersions = branch.Branches?[0].Name;
            AdvisoryUrl = csafObj.Document?.References?.Find(r => r.Category.ToLower() == "self")?.Url ?? csafObj.Document?.References[0]?.Url;

            if (csafObj.Vulnerabilities != null)
            {
                foreach (var vulnerability in csafObj.Vulnerabilities)
                {
                    if (vulnerability.Product_Status.Known_Affected.Contains(branch.Branches?[0].Product?.Product_Id))
                    {
                        Vulnerabilities.Add(vulnerability);
                    }
                }
            }
        }

        public string Name { get; set; }
        public string AdvisoryUrl { get; set; }
        public List<CommonSecurityAdvisoryFrameworkObject.Vulnerability> Vulnerabilities { get; set; }
        public string AffectedVersions { get; set; }
    }
}
