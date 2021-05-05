using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class COMPONENT_FAMILY
    {
        public COMPONENT_FAMILY()
        {
            COMPONENT_SYMBOLS = new HashSet<COMPONENT_SYMBOLS>();
        }

        [StringLength(150)]
        public string Component_Family_Name { get; set; }

        [InverseProperty("Component_Family_NameNavigation")]
        public virtual ICollection<COMPONENT_SYMBOLS> COMPONENT_SYMBOLS { get; set; }
    }
}