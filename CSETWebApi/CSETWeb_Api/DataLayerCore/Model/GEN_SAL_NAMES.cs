using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class GEN_SAL_NAMES
    {
        public GEN_SAL_NAMES()
        {
            GENERAL_SAL = new HashSet<GENERAL_SAL>();
            GEN_SAL_WEIGHTS = new HashSet<GEN_SAL_WEIGHTS>();
        }

        public string Sal_Name { get; set; }

        public virtual ICollection<GENERAL_SAL> GENERAL_SAL { get; set; }
        public virtual ICollection<GEN_SAL_WEIGHTS> GEN_SAL_WEIGHTS { get; set; }
    }
}
