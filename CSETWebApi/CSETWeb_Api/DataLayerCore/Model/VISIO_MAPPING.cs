using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class VISIO_MAPPING
    {
        public string Specific_Type { get; set; }
        public string Stencil_Name { get; set; }

        public virtual DIAGRAM_TYPES Specific_TypeNavigation { get; set; }
    }
}
