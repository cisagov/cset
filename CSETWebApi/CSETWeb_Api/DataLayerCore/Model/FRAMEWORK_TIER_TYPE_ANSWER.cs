using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FRAMEWORK_TIER_TYPE_ANSWER
    {
        public int Assessment_Id { get; set; }
        public string TierType { get; set; }
        public string Tier { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual FRAMEWORK_TIERS TierNavigation { get; set; }
        public virtual FRAMEWORK_TIER_TYPE TierTypeNavigation { get; set; }
    }
}
