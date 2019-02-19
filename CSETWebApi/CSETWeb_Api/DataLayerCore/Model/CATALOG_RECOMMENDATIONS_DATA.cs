using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class CATALOG_RECOMMENDATIONS_DATA
    {
        public CATALOG_RECOMMENDATIONS_DATA()
        {
            RECOMMENDATIONS_REFERENCES = new HashSet<RECOMMENDATIONS_REFERENCES>();
        }

        public int Data_Id { get; set; }
        public int? Req_Oracle_Id { get; set; }
        public int? Parent_Heading_Id { get; set; }
        public string Heading { get; set; }
        public string Heading_Html { get; set; }
        [StringLength(50)]
        public string Section_Long_Number { get; set; }
        [StringLength(50)]
        public string Section_Short_Number { get; set; }
        [StringLength(150)]
        public string Topic_Name { get; set; }
        [StringLength(150)]
        public string Section_Short_Name { get; set; }
        public string Requirement_Text { get; set; }
        public string Supplemental_Guidance { get; set; }
        public string Supplemental_Guidance_Html { get; set; }
        public string Requirement { get; set; }
        public string Requirement_Html { get; set; }
        public string Enhancement { get; set; }
        public string Enhancement_Html { get; set; }
        public string Flow_Document { get; set; }

        [ForeignKey("Parent_Heading_Id")]
        [InverseProperty("CATALOG_RECOMMENDATIONS_DATA")]
        public virtual CATALOG_RECOMMENDATIONS_HEADINGS Parent_Heading_ { get; set; }
        [InverseProperty("Data_")]
        public virtual ICollection<RECOMMENDATIONS_REFERENCES> RECOMMENDATIONS_REFERENCES { get; set; }
    }
}
