using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_HOURS_COMPONENT
    {
        public FINANCIAL_HOURS_COMPONENT()
        {
            FINANCIAL_HOURS = new HashSet<FINANCIAL_HOURS>();
        }

        [Key]
        [StringLength(50)]
        public string Component { get; set; }
        public int? DomainId { get; set; }
        public int? PresentationOrder { get; set; }

        [ForeignKey("DomainId")]
        [InverseProperty("FINANCIAL_HOURS_COMPONENT")]
        public virtual FINANCIAL_DOMAINS Domain { get; set; }
        [InverseProperty("ComponentNavigation")]
        public virtual ICollection<FINANCIAL_HOURS> FINANCIAL_HOURS { get; set; }
    }
}
