//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Mvra;

public class CapabilityScore
{
    public string Title { get; set; }
    public List<LevelScore> LevelScores { get; set; }
}