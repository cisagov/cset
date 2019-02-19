using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FRAMEWORK_TIER_TYPE
    {
        public FRAMEWORK_TIER_TYPE()
        {
            FRAMEWORK_TIER_TYPE_ANSWER = new HashSet<FRAMEWORK_TIER_TYPE_ANSWER>();
        }

        public string TierType { get; set; }

        public virtual ICollection<FRAMEWORK_TIER_TYPE_ANSWER> FRAMEWORK_TIER_TYPE_ANSWER { get; set; }
    }
}
