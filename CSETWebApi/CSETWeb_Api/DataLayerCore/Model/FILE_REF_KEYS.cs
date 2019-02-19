using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FILE_REF_KEYS
    {
        public FILE_REF_KEYS()
        {
            GEN_FILE = new HashSet<GEN_FILE>();
            STANDARD_SOURCE_FILE = new HashSet<STANDARD_SOURCE_FILE>();
        }

        public string Doc_Num { get; set; }

        public virtual ICollection<GEN_FILE> GEN_FILE { get; set; }
        public virtual ICollection<STANDARD_SOURCE_FILE> STANDARD_SOURCE_FILE { get; set; }
    }
}
