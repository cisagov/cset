using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_OBJECT_TYPES
    {
        public DIAGRAM_OBJECT_TYPES()
        {
            DIAGRAM_TYPES = new HashSet<DIAGRAM_TYPES>();
        }

        public string Object_Type { get; set; }
        public int? Object_Type_Order { get; set; }

        public virtual ICollection<DIAGRAM_TYPES> DIAGRAM_TYPES { get; set; }
    }
}
