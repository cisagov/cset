using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FRAMEWORK_TIER_TYPE
    {
        public FRAMEWORK_TIER_TYPE()
        {
            FRAMEWORK_TIER_TYPE_ANSWER = new HashSet<FRAMEWORK_TIER_TYPE_ANSWER>();
        }

        [Key]
        [StringLength(50)]
        public string TierType { get; set; }

        [InverseProperty("TierTypeNavigation")]
        public virtual ICollection<FRAMEWORK_TIER_TYPE_ANSWER> FRAMEWORK_TIER_TYPE_ANSWER { get; set; }
    }
}