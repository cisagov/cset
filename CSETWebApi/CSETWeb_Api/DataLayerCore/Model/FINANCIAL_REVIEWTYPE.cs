using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_REVIEWTYPE
    {
        public FINANCIAL_REVIEWTYPE()
        {
            FINANCIAL_HOURS = new HashSet<FINANCIAL_HOURS>();
        }

        [Key]
        [StringLength(50)]
        public string ReviewType { get; set; }

        [InverseProperty("ReviewTypeNavigation")]
        public virtual ICollection<FINANCIAL_HOURS> FINANCIAL_HOURS { get; set; }
    }
}
