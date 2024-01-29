//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;


namespace CSETWebCore.Model.C2M2.Charts
{
    /// <summary>
    /// A row of answers for the heatmap, grouped by MIL
    /// </summary>
    public class HeatmapRow
    {
        public string Title { get; set; }
        public List<HeatmapPractice> Practices { get; set; } = new List<HeatmapPractice>();
    }


    /// <summary>
    /// A single answer in the heatmap
    /// </summary>
    public class HeatmapPractice
    {
        public string Number { get; set; }
        public string Answer { get; set; }
    }
}
