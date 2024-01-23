//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Maturity
{
    public class MaturityModel
    {
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public int MaturityTargetLevel { get; set; }
        public List<MaturityLevel> Levels { get; set; }
        public string QuestionsAlias { get; set; }
        public string ModelDescription { get; set; }
        public string ModelTitle { get; set; }
        public int? IconId { get; set; }
    }
}
