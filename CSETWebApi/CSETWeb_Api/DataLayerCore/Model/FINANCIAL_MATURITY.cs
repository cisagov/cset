using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_MATURITY
    {
        public FINANCIAL_MATURITY()
        {
            FINANCIAL_DETAILS = new HashSet<FINANCIAL_DETAILS>();
        }

        [Key]
        public int MaturityId { get; set; }
        [Required]
        [StringLength(255)]
        public string MaturityLevel { get; set; }

        [InverseProperty("Maturity")]
        public virtual ICollection<FINANCIAL_DETAILS> FINANCIAL_DETAILS { get; set; }
    }
}
