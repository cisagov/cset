using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FRAMEWORK_TIERS
    {
        public FRAMEWORK_TIERS()
        {
            FRAMEWORK_TIER_DEFINITIONS = new HashSet<FRAMEWORK_TIER_DEFINITIONS>();
            FRAMEWORK_TIER_TYPE_ANSWER = new HashSet<FRAMEWORK_TIER_TYPE_ANSWER>();
        }

        [Key]
        [StringLength(50)]
        public string Tier { get; set; }
        [Required]
        [StringLength(50)]
        public string FullName { get; set; }
        public int TierOrder { get; set; }

        [InverseProperty("TierNavigation")]
        public virtual ICollection<FRAMEWORK_TIER_DEFINITIONS> FRAMEWORK_TIER_DEFINITIONS { get; set; }
        [InverseProperty("TierNavigation")]
        public virtual ICollection<FRAMEWORK_TIER_TYPE_ANSWER> FRAMEWORK_TIER_TYPE_ANSWER { get; set; }
    }
}
