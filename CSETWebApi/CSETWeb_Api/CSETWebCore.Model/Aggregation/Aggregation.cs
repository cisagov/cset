using System;

namespace CSETWebCore.Model.Aggregation
{
    public class Aggregation
    {
        public int AggregationId { get; set; }
        public string AggregationName { get; set; }
        public DateTime? AggregationDate { get; set; }
        public string Mode { get; set; }
        public string AssessorName { get; set; }

        public float QuestionsCompatibility { get; set; }
        public float RequirementsCompatibility { get; set; }
    }
}