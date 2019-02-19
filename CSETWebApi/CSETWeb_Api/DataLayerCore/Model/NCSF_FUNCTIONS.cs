using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NCSF_FUNCTIONS
    {
        public NCSF_FUNCTIONS()
        {
            NCSF_CATEGORY = new HashSet<NCSF_CATEGORY>();
        }

        public string NCSF_Function_ID { get; set; }
        public string NCSF_Function_Name { get; set; }
        public int? NCSF_Function_Order { get; set; }
        public int NCSF_ID { get; set; }

        public virtual ICollection<NCSF_CATEGORY> NCSF_CATEGORY { get; set; }
    }
}
