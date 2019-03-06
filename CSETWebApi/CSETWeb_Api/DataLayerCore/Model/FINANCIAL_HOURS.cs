using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_HOURS
    {
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public string Component { get; set; }
        [StringLength(50)]
        public string ReviewType { get; set; }
        [Column(TypeName = "decimal(9, 2)")]
        public decimal Hours { get; set; }
        public int? ReviewedCountOverride { get; set; }
        [StringLength(512)]
        public string OtherSpecifyValue { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("FINANCIAL_HOURS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Component")]
        [InverseProperty("FINANCIAL_HOURS")]
        public virtual FINANCIAL_HOURS_COMPONENT ComponentNavigation { get; set; }
        [ForeignKey("ReviewType")]
        [InverseProperty("FINANCIAL_HOURS")]
        public virtual FINANCIAL_REVIEWTYPE ReviewTypeNavigation { get; set; }
    }
}
