using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_TIERS
    {
        public int StmtNumber { get; set; }
        [StringLength(255)]
        public string Label { get; set; }

        [ForeignKey("StmtNumber")]
        [InverseProperty("FINANCIAL_TIERS")]
        public virtual FINANCIAL_DETAILS StmtNumberNavigation { get; set; }
    }
}
