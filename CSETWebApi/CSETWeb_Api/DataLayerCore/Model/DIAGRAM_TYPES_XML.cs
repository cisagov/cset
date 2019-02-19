using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_TYPES_XML
    {
        public DIAGRAM_TYPES_XML()
        {
            DIAGRAM_TYPES = new HashSet<DIAGRAM_TYPES>();
        }

        public string Diagram_Type_XML { get; set; }

        public virtual COMPONENT_SYMBOLS COMPONENT_SYMBOLS { get; set; }
        public virtual SHAPE_TYPES SHAPE_TYPES { get; set; }
        public virtual ICollection<DIAGRAM_TYPES> DIAGRAM_TYPES { get; set; }
    }
}
