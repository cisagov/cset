using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class CNSS_CIA_TYPES
    {
        public CNSS_CIA_TYPES()
        {
            CNSS_CIA_JUSTIFICATIONS = new HashSet<CNSS_CIA_JUSTIFICATIONS>();
        }

        public string CIA_Type { get; set; }

        public virtual ICollection<CNSS_CIA_JUSTIFICATIONS> CNSS_CIA_JUSTIFICATIONS { get; set; }
    }
}
