using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FRAMEWORK_TIER_DEFINITIONS
    {
        public string Tier { get; set; }
        public string TierType { get; set; }
        public string TierQuestion { get; set; }

        public virtual FRAMEWORK_TIERS TierNavigation { get; set; }
    }
}
