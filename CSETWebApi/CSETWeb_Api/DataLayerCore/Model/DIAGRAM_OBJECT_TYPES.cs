using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_OBJECT_TYPES
    {
        public DIAGRAM_OBJECT_TYPES()
        {
            DIAGRAM_TYPES = new HashSet<DIAGRAM_TYPES>();
        }

        [Key]
        [StringLength(100)]
        public string Object_Type { get; set; }
        public int? Object_Type_Order { get; set; }

        [InverseProperty("Object_TypeNavigation")]
        public virtual ICollection<DIAGRAM_TYPES> DIAGRAM_TYPES { get; set; }
    }
}
