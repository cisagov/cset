using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class INFORMATION
    {
        public int Id { get; set; }
        [Required]
        [StringLength(100)]
        public string Assessment_Name { get; set; }
        [StringLength(100)]
        public string Facility_Name { get; set; }
        [StringLength(100)]
        public string City_Or_Site_Name { get; set; }
        [StringLength(100)]
        public string State_Province_Or_Region { get; set; }
        [StringLength(100)]
        public string Assessor_Name { get; set; }
        [StringLength(100)]
        public string Assessor_Email { get; set; }
        [StringLength(100)]
        public string Assessor_Phone { get; set; }
        [StringLength(4000)]
        public string Assessment_Description { get; set; }
        [StringLength(4000)]
        public string Additional_Notes_And_Comments { get; set; }
        [Column(TypeName = "ntext")]
        public string Additional_Contacts { get; set; }
        [Column(TypeName = "ntext")]
        public string Executive_Summary { get; set; }
        [Column(TypeName = "ntext")]
        public string Enterprise_Evaluation_Summary { get; set; }
        [StringLength(70)]
        public string Real_Property_Unique_Id { get; set; }
        public int? eMass_Document_Id { get; set; }

        [ForeignKey("Id")]
        [InverseProperty("INFORMATION")]
        public virtual ASSESSMENTS IdNavigation { get; set; }
        [ForeignKey("eMass_Document_Id")]
        [InverseProperty("INFORMATION")]
        public virtual DOCUMENT_FILE eMass_Document_ { get; set; }
    }
}