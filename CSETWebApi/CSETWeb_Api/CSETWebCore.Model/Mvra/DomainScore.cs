//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Mvra;

public class DomainScore
{
    public string Title { get; set; }
    public string Rating { get; set; }
    public string Credit { get; set; }

    public List<LevelScore> LevelScores { get; set; }

    public List<CapabilityScore> CapabilityScores { get; set; }
}