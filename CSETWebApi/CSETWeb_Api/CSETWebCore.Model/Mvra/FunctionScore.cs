//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Mvra;

public class FunctionScore
{
    public string Title { get; set; }
    public int Credit { get; set; }

    public List<LevelScore> LevelScores { get; set; }

    public List<DomainScore> DomainScores { get; set; }
}