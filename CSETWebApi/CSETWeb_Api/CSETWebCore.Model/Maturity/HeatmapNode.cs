//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;


namespace CSETWebCore.Model.Maturity
{
    /// <summary>
    /// Represents a 'chiclet' on the heatmap display
    /// </summary>
    public class HeatmapNode
    {
        public int GroupingId { get; set; }

        public int QuestionId { get; set; }

        public string Title { get; set; }

        /// <summary>
        /// The question's title as defined with no formatting
        /// </summary>
        public string FullTitle { get; set; }

        public string Color { get; set; }

        /// <summary>
        /// A non-displayed internal color for non-answered nodes to 
        /// hold a rollup color value based on their children.
        /// </summary>
        public string RollupColor { get; set; }

        public List<HeatmapNode> Children { get; set; } = [];
    }
}
