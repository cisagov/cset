using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_TYPES_XML
    {
        public DIAGRAM_TYPES_XML()
        {
            DIAGRAM_TYPES = new HashSet<DIAGRAM_TYPES>();
        }

        [StringLength(50)]
        public string Diagram_Type_XML { get; set; }

        [InverseProperty("Diagram_Type_XmlNavigation")]
        public virtual COMPONENT_SYMBOLS COMPONENT_SYMBOLS { get; set; }
        [InverseProperty("Diagram_Type_XMLNavigation")]
        public virtual SHAPE_TYPES SHAPE_TYPES { get; set; }
        [InverseProperty("Diagram_Type_XMLNavigation")]
        public virtual ICollection<DIAGRAM_TYPES> DIAGRAM_TYPES { get; set; }
    }
}