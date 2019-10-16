using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_TYPES
    {
        public DIAGRAM_TYPES()
        {
            VISIO_MAPPING = new HashSet<VISIO_MAPPING>();
        }

        [Key]
        [StringLength(100)]
        public string Specific_Type { get; set; }
        [StringLength(50)]
        public string Diagram_Type_XML { get; set; }
        [StringLength(100)]
        public string Object_Type { get; set; }

        [ForeignKey("Object_Type")]
        [InverseProperty("DIAGRAM_TYPES")]
        public virtual DIAGRAM_OBJECT_TYPES Object_TypeNavigation { get; set; }
        [InverseProperty("Specific_TypeNavigation")]
        public virtual ICollection<VISIO_MAPPING> VISIO_MAPPING { get; set; }
    }
}