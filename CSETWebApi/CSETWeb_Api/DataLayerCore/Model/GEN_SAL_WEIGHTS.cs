using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class GEN_SAL_WEIGHTS
    {
        public int Sal_Weight_Id { get; set; }
        [StringLength(50)]
        public string Sal_Name { get; set; }
        public int Slider_Value { get; set; }
        [Column(TypeName = "decimal(18, 0)")]
        public decimal Weight { get; set; }
        [Required]
        [StringLength(50)]
        public string Display { get; set; }

        [ForeignKey("Sal_Name")]
        [InverseProperty("GEN_SAL_WEIGHTS")]
        public virtual GEN_SAL_NAMES Sal_Name1 { get; set; }
        [ForeignKey("Sal_Name")]
        [InverseProperty("GEN_SAL_WEIGHTS")]
        public virtual GENERAL_SAL_DESCRIPTIONS Sal_NameNavigation { get; set; }
    }
}
