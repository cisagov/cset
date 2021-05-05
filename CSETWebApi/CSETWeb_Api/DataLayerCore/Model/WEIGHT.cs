using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class WEIGHT
    {
        [Column("Weight")]
        public int Weight1 { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Question_Normalized_Weight { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Requirement_Normalized_Weight { get; set; }
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? Category_Normalized_Weight { get; set; }
    }
}