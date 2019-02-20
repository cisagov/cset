using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DomainStandardCategory
    {
        public int DominId { get; set; }
        [Required]
        [StringLength(200)]
        public string DomainName { get; set; }
        [Required]
        [StringLength(250)]
        public string Standard_Category { get; set; }

        [ForeignKey("Standard_Category")]
        [InverseProperty("DomainStandardCategory")]
        public virtual STANDARD_CATEGORY Standard_CategoryNavigation { get; set; }
    }
}
