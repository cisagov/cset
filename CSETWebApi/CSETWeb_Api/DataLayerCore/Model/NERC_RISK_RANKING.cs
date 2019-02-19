using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class NERC_RISK_RANKING
    {
        public int? Question_id { get; set; }
        public int? Requirement_Id { get; set; }
        [Key]
        public int Compliance_Risk_Rank { get; set; }
        [Required]
        [StringLength(50)]
        public string Violation_Risk_Factor { get; set; }

        [ForeignKey("Question_id")]
        [InverseProperty("NERC_RISK_RANKING")]
        public virtual NEW_QUESTION Question_ { get; set; }
        [ForeignKey("Requirement_Id")]
        [InverseProperty("NERC_RISK_RANKING")]
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}
