using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class SAL_DETERMINATION_TYPES
    {
        public SAL_DETERMINATION_TYPES()
        {
            STANDARD_SELECTION = new HashSet<STANDARD_SELECTION>();
        }

        [StringLength(50)]
        public string Sal_Determination_Type { get; set; }

        [InverseProperty("Last_Sal_Determination_TypeNavigation")]
        public virtual ICollection<STANDARD_SELECTION> STANDARD_SELECTION { get; set; }
    }
}