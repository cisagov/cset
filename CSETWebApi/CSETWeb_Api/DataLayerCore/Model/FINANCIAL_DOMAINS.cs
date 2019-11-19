using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_DOMAINS
    {
        public FINANCIAL_DOMAINS()
        {
            FINANCIAL_DOMAIN_FILTERS = new HashSet<FINANCIAL_DOMAIN_FILTERS>();
            FINANCIAL_GROUPS = new HashSet<FINANCIAL_GROUPS>();
            FINANCIAL_HOURS_COMPONENT = new HashSet<FINANCIAL_HOURS_COMPONENT>();
        }

        [Required]
        [StringLength(255)]
        public string Domain { get; set; }
        [Key]
        public int DomainId { get; set; }
        [StringLength(50)]
        public string Acronym { get; set; }

        [InverseProperty("Domain")]
        public virtual ICollection<FINANCIAL_DOMAIN_FILTERS> FINANCIAL_DOMAIN_FILTERS { get; set; }
        [InverseProperty("Domain")]
        public virtual ICollection<FINANCIAL_GROUPS> FINANCIAL_GROUPS { get; set; }
        [InverseProperty("Domain")]
        public virtual ICollection<FINANCIAL_HOURS_COMPONENT> FINANCIAL_HOURS_COMPONENT { get; set; }
    }
}