using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_GROUPS
    {
        public FINANCIAL_GROUPS()
        {
            FINANCIAL_DETAILS = new HashSet<FINANCIAL_DETAILS>();
        }

        [Key]
        public int FinancialGroupId { get; set; }
        public int DomainId { get; set; }
        public int AssessmentFactorId { get; set; }
        public int FinComponentId { get; set; }
        public int MaturityId { get; set; }

        [ForeignKey("AssessmentFactorId")]
        [InverseProperty("FINANCIAL_GROUPS")]
        public virtual FINANCIAL_ASSESSMENT_FACTORS AssessmentFactor { get; set; }
        [ForeignKey("DomainId")]
        [InverseProperty("FINANCIAL_GROUPS")]
        public virtual FINANCIAL_DOMAINS Domain { get; set; }
        [ForeignKey("FinComponentId")]
        [InverseProperty("FINANCIAL_GROUPS")]
        public virtual FINANCIAL_COMPONENTS FinComponent { get; set; }
        [ForeignKey("MaturityId")]
        [InverseProperty("FINANCIAL_GROUPS")]
        public virtual FINANCIAL_MATURITY Maturity { get; set; }
        [InverseProperty("FinancialGroup")]
        public virtual ICollection<FINANCIAL_DETAILS> FINANCIAL_DETAILS { get; set; }
    }
}