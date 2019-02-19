using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class GENERAL_SAL_DESCRIPTIONS
    {
        public GENERAL_SAL_DESCRIPTIONS()
        {
            GEN_SAL_WEIGHTS = new HashSet<GEN_SAL_WEIGHTS>();
        }

        public string Sal_Name { get; set; }
        public string Sal_Description { get; set; }
        public int Sal_Order { get; set; }
        public int? min { get; set; }
        public int? max { get; set; }
        public int? step { get; set; }
        public string prefix { get; set; }
        public string postfix { get; set; }

        public virtual ICollection<GEN_SAL_WEIGHTS> GEN_SAL_WEIGHTS { get; set; }
    }
}
