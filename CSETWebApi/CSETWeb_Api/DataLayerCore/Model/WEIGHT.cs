using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class WEIGHT
    {
        public int Weight1 { get; set; }
        public decimal Question_Normalized_Weight { get; set; }
        public decimal Requirement_Normalized_Weight { get; set; }
        public decimal? Category_Normalized_Weight { get; set; }
    }
}
