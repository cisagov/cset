using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_TYPES
    {
        public DIAGRAM_TYPES()
        {
            VISIO_MAPPING = new HashSet<VISIO_MAPPING>();
        }

        public string Specific_Type { get; set; }
        public string Diagram_Type_XML { get; set; }
        public string Object_Type { get; set; }

        public virtual DIAGRAM_TYPES_XML Diagram_Type_XMLNavigation { get; set; }
        public virtual DIAGRAM_OBJECT_TYPES Object_TypeNavigation { get; set; }
        public virtual ICollection<VISIO_MAPPING> VISIO_MAPPING { get; set; }
    }
}
