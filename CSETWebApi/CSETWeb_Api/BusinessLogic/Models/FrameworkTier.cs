//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSETWeb_Api.Models
{
    /// <summary>
    /// Defines the aggregate response when the UI needs to know the questions, tiers and selected values.
    /// </summary>
    public class FrameworkResponse
    {
        /// <summary>
        /// A list of tier types (questions) to be asked.
        /// </summary>
        public List<FrameworkTierType> TierTypes = new List<FrameworkTierType>();
    }


    /// <summary>
    /// A 'tier type' represents the overarching question that is answered by selecting Tier 1, Tier 2, etc.
    /// </summary>
    public class FrameworkTierType
    {
        /// <summary>
        /// The name of the tier type, e.g., External Participation, Integrated Risk Management Program, etc.
        /// </summary>
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


    /// <summary>
    /// Describes a tier option.
    /// </summary>
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

        public Boolean Selected;

        /// <summary>
        /// A unique value that can be used for labeling radio buttons in the UI.
        /// </summary>
        public string ControlId;
    }


    /// <summary>
    /// This is what the UI sends when the user selects a tier.
    /// </summary>
    public class TierSelection
    {
        /// <summary>
        /// The type of the tier group.
        /// </summary>
        public string TierType;

        /// <summary>
        /// The name of the tier, e.g., Tier 1, Tier 2, etc.
        /// </summary>
        public string TierName;

    }
}

