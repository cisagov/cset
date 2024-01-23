//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Model.Framework
{
    public class FrameworkTier
    {
        /// <summary>
        /// The name of the tier
        /// </summary>
        public string TierName;

        /// <summary>
        /// The descriptive text for the tier.
        /// </summary>
        public string Question;

        public bool Selected;

        /// <summary>
        /// A unique value that can be used for labeling radio buttons in the UI.
        /// </summary>
        public string ControlId;
    }
}