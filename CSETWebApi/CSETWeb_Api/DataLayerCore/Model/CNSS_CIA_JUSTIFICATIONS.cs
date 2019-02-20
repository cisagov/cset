using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class CNSS_CIA_JUSTIFICATIONS
    {
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public string CIA_Type { get; set; }
        [Required]
        [StringLength(50)]
        public string DropDownValueLevel { get; set; }
        [Required]
        [StringLength(1500)]
        public string Justification { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("CNSS_CIA_JUSTIFICATIONS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("CIA_Type")]
        [InverseProperty("CNSS_CIA_JUSTIFICATIONS")]
        public virtual CNSS_CIA_TYPES CIA_TypeNavigation { get; set; }
    }
}
