using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class FINANCIAL_COMPONENTS
    {
        public FINANCIAL_COMPONENTS()
        {
            FINANCIAL_GROUPS = new HashSet<FINANCIAL_GROUPS>();
        }

        [Key]
        public int FinComponentId { get; set; }
        [Required]
        [StringLength(255)]
        public string FinComponent { get; set; }
        [StringLength(50)]
        public string Acronym { get; set; }
        public int? Number { get; set; }

        [InverseProperty("FinComponent")]
        public virtual ICollection<FINANCIAL_GROUPS> FINANCIAL_GROUPS { get; set; }
    }
}