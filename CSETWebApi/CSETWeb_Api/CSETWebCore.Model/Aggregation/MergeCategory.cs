using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class MergeCategory
    {
        public string Category { get; set; }
        public List<MergeQuestion> Questions = new List<MergeQuestion>();
    }
}