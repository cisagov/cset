using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SHAPE_TYPES
    {
        public string Diagram_Type_XML { get; set; }
        public string Telerik_Shape_Type { get; set; }
        public string Visio_Shape_Type { get; set; }
        public bool IsDefault { get; set; }
        public string DisplayName { get; set; }

        public virtual DIAGRAM_TYPES_XML Diagram_Type_XMLNavigation { get; set; }
    }
}
