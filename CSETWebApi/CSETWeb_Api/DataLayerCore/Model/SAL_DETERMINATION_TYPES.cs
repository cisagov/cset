using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SAL_DETERMINATION_TYPES
    {
        public SAL_DETERMINATION_TYPES()
        {
            STANDARD_SELECTION = new HashSet<STANDARD_SELECTION>();
        }

        public string Sal_Determination_Type { get; set; }

        public virtual ICollection<STANDARD_SELECTION> STANDARD_SELECTION { get; set; }
    }
}
