using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FRAMEWORK_TIER_TYPE_ANSWER
    {
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public string TierType { get; set; }
        [Required]
        [StringLength(50)]
        public string Tier { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("FRAMEWORK_TIER_TYPE_ANSWER")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Tier")]
        [InverseProperty("FRAMEWORK_TIER_TYPE_ANSWER")]
        public virtual FRAMEWORK_TIERS TierNavigation { get; set; }
        [ForeignKey("TierType")]
        [InverseProperty("FRAMEWORK_TIER_TYPE_ANSWER")]
        public virtual FRAMEWORK_TIER_TYPE TierTypeNavigation { get; set; }
    }
}
