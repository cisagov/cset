using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class CNSS_CIA_TYPES
    {
        public CNSS_CIA_TYPES()
        {
            CNSS_CIA_JUSTIFICATIONS = new HashSet<CNSS_CIA_JUSTIFICATIONS>();
        }

        [Key]
        [StringLength(50)]
        public string CIA_Type { get; set; }

        [InverseProperty("CIA_TypeNavigation")]
        public virtual ICollection<CNSS_CIA_JUSTIFICATIONS> CNSS_CIA_JUSTIFICATIONS { get; set; }
    }
}