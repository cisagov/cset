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
    }
}
