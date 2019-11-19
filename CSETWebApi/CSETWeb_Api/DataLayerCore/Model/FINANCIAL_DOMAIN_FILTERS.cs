using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_DOMAIN_FILTERS
    {
        public int Assessment_Id { get; set; }
        public int DomainId { get; set; }
        public bool B { get; set; }
        public bool E { get; set; }
        public bool Int { get; set; }
        public bool A { get; set; }
        public bool Inn { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("FINANCIAL_DOMAIN_FILTERS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("DomainId")]
        [InverseProperty("FINANCIAL_DOMAIN_FILTERS")]
        public virtual FINANCIAL_DOMAINS Domain { get; set; }
    }
}