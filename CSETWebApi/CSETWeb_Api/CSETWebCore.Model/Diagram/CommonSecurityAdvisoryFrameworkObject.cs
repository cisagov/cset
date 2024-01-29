//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Nested;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Diagram
{
    public class CommonSecurityAdvisoryFrameworkObject
    {

        public CommonSecurityAdvisoryFrameworkObject() { }

        public CommonSecurityAdvisoryFrameworkObject(CommonSecurityAdvisoryFrameworkVendor vendor)
        {
            Product_Tree = new ProductTree();
            Product_Tree.Branches = new List<Branch> { new Branch { Name = vendor.Name } };
            foreach (var product in vendor.Products)
            {
                Product_Tree.Branches[0].Branches.Add(new Branch { Name = product.Name });
            }
        }

        public DocumentClass Document { get; set; }
        public ProductTree Product_Tree { get; set; }
        public List<Vulnerability> Vulnerabilities { get; set; }

        public class Acknowledgment
        {
            public string Summary { get; set; }
        }

        public class Branch
        {
            public List<Branch> Branches { get; set; }
            public string Category { get; set; }
            public string Name { get; set; }
            public Product Product { get; set; }
        }

        public class CvssV3
        {
            public double BaseScore { get; set; }
            public string BaseSeverity { get; set; }
            public string VectorString { get; set; }
            public string Version { get; set; }
        }

        public class Cwe
        {
            public string Id { get; set; }
            public string Name { get; set; }
        }

        public class Distribution
        {
            public string Text { get; set; }
            public Tlp Tlp { get; set; }
        }

        public class DocumentClass
        {
            public List<Acknowledgment> Acknowledgments { get; set; }
            public string Category { get; set; }
            public string Csaf_Version { get; set; }
            public Distribution Distribution { get; set; }
            public string Lang { get; set; }
            public List<Note> Notes { get; set; }
            public Publisher Publisher { get; set; }
            public List<Reference> References { get; set; }
            public string Title { get; set; }
            public Tracking Tracking { get; set; }
        }

        public class Engine
        {
            public string Name { get; set; }
            public string Version { get; set; }
        }

        public class Generator
        {
            public Engine Engine { get; set; }
        }

        public class Note
        {
            public string Category { get; set; }
            public string Text { get; set; }
            public string Title { get; set; }
        }

        public class Product
        {
            public string Name { get; set; }
            public string Product_Id { get; set; }
        }

        public class ProductStatus
        {
            public List<string> Known_Affected { get; set; }
        }

        public class ProductTree
        {
            public List<Branch> Branches { get; set; }
        }

        public class Publisher
        {
            public string Category { get; set; }
            public string Contact_Details { get; set; }
            public string Name { get; set; }
            public string Namespace { get; set; }
        }

        public class Reference
        {
            public string Category { get; set; }
            public string Summary { get; set; }
            public string Url { get; set; }
        }

        public class Remediation
        {
            public string Category { get; set; }
            public string Details { get; set; }
            public List<string> Product_Ids { get; set; }
            public string Url { get; set; }
        }

        public class RevisionHistory
        {
            public DateTime Date { get; set; }
            public string Legacy_Version { get; set; }
            public string Number { get; set; }
            public string Summary { get; set; }
        }

        public class Score
        {
            public CvssV3 Cvss_V3 { get; set; }
            public List<string> Products { get; set; }
        }

        public class Tlp
        {
            public string Label { get; set; }
            public string Url { get; set; }
        }

        public class Tracking
        {
            public DateTime Current_Release_Date { get; set; }
            public Generator Generator { get; set; }
            public string Id { get; set; }
            public DateTime Initial_Release_Date { get; set; }
            public List<RevisionHistory> Revision_History { get; set; }
            public string Status { get; set; }
            public string Version { get; set; }
        }

        public class Vulnerability
        {
            public string Cve { get; set; }
            public Cwe Cwe { get; set; }
            public List<Note> Notes { get; set; }
            public ProductStatus Product_Status { get; set; }
            public List<Reference> References { get; set; }
            public List<Remediation> Remediations { get; set; }
            public List<Score> Scores { get; set; }
            public string Title { get; set; }
        }

    }
}
