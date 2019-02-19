using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class COMPONENT_FAMILY
    {
        public COMPONENT_FAMILY()
        {
            COMPONENT_SYMBOLS = new HashSet<COMPONENT_SYMBOLS>();
        }

        public string Component_Family_Name { get; set; }

        public virtual ICollection<COMPONENT_SYMBOLS> COMPONENT_SYMBOLS { get; set; }
    }
}
