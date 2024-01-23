//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Framework
{
    public class FrameworkTierType
    {
        public string TierType;

        /// <summary>
        /// A unique string built from the tier type.  It is used by the UI to define radio button grouping.
        /// </summary>
        public string GroupName;

        /// <summary>
        /// A list of tiers (options) for this question.
        /// </summary>
        public List<FrameworkTier> Tiers = new List<FrameworkTier>();

        /// <summary>
        /// Indicates which tier (option) is currently selected for this tier type.
        /// </summary>
        public string SelectedTier;
    }
}