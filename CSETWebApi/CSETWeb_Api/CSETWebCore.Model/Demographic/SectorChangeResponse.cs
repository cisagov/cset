//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Demographic
{
    public class SectorChangeResponse
    {
        public List<ListItem2> Subsectors { get; set; } = [];

        public int? CompletedCount { get; set; }
        public int? TotalMaturityQuestionsCount { get; set; }
        public int? TotalDiagramQuestionsCount { get; set; }
        public int? TotalStandardQuestionsCount { get; set; }
    }
}
