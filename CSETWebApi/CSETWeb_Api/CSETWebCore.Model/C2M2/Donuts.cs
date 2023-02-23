//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;


namespace CSETWebCore.Model.C2M2.Charts
{
    /// <summary>
    /// A Domain in the report.
    /// </summary>
    public class Domain
    {
        public string Title { get; set; }
        public int Sequence { get; set; }
        public string Description { get; set; }
        public List<Objective> Objectives { get; set; } = new List<Objective>();

        public List<HeatmapRow> HeatmapRows { get; set; } = new List<HeatmapRow>();
    }


    /// <summary>
    /// Answer counts for the objective donut charts.
    /// </summary>
    public class Objective
    {
        public string Title { get; set; }
        public int FI { get; set; }
        public int LI { get; set; }
        public int PI { get; set; }
        public int NI { get; set; }
        public int U { get; set; }
    }
}
