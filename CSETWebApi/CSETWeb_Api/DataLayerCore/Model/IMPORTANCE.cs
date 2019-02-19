using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class IMPORTANCE
    {
        public IMPORTANCE()
        {
            FINDING = new HashSet<FINDING>();
        }

        public int Importance_Id { get; set; }
        public string Value { get; set; }

        public virtual ICollection<FINDING> FINDING { get; set; }
    }
}
