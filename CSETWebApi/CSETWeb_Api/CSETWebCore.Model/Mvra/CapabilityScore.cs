using System.Collections.Generic;

namespace CSETWebCore.Model.Mvra;

public class CapabilityScore
{
    public string Title { get; set; }
    public List<LevelScore> LevelScores { get; set; }
}