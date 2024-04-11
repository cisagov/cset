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
    /// A Domain in the report.
    /// </summary>
    public class Domain
    {
        public string Title { get; set; }
        public string ShortTitle { get; set; }
        public int Sequence { get; set; }
        public string Description { get; set; }

        /// <summary>
        /// Composite answer counts at the Domain level.
        /// </summary>
        public List<MilRollup> DomainMilRollup { get; set; } = new List<MilRollup>();

        /// <summary>
        /// The highest MIL that is 100% implemented for the Domain.
        /// </summary>
        public int MilAchieved { get; set; }

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


    /// <summary>
    /// Answer counts for each MIL level within a Domain
    /// </summary>
    public class MilRollup
    {
        public int Level { get; set; }
        public string MilName { get; set; }

        public int FI { get; set; }
        public int LI { get; set; }
        public int PI { get; set; }
        public int NI { get; set; }
        public int U { get; set; }
    }
}
