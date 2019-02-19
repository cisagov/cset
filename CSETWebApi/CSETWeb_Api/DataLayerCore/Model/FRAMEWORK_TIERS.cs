using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FRAMEWORK_TIERS
    {
        public FRAMEWORK_TIERS()
        {
            FRAMEWORK_TIER_DEFINITIONS = new HashSet<FRAMEWORK_TIER_DEFINITIONS>();
            FRAMEWORK_TIER_TYPE_ANSWER = new HashSet<FRAMEWORK_TIER_TYPE_ANSWER>();
        }

        public string Tier { get; set; }
        public string FullName { get; set; }
        public int TierOrder { get; set; }

        public virtual ICollection<FRAMEWORK_TIER_DEFINITIONS> FRAMEWORK_TIER_DEFINITIONS { get; set; }
        public virtual ICollection<FRAMEWORK_TIER_TYPE_ANSWER> FRAMEWORK_TIER_TYPE_ANSWER { get; set; }
    }
}
