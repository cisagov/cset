//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Mvra;

public class LevelScore
{
    public string Level { get; set; }
    public int TotalPassed { get; set; }
    public int TotalTiers { get; set; }
    public int Credit { get; set; }
}