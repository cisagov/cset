using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class FRAMEWORK_TIER_DEFINITIONS
    {
        [StringLength(50)]
        public string Tier { get; set; }
        [StringLength(50)]
        public string TierType { get; set; }
        [Required]
        [StringLength(1024)]
        public string TierQuestion { get; set; }

        [ForeignKey("Tier")]
        [InverseProperty("FRAMEWORK_TIER_DEFINITIONS")]
        public virtual FRAMEWORK_TIERS TierNavigation { get; set; }
    }
}