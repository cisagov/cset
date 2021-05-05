using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class VISIO_MAPPING
    {
        [StringLength(100)]
        public string Specific_Type { get; set; }
        [StringLength(200)]
        public string Stencil_Name { get; set; }

        [ForeignKey("Specific_Type")]
        [InverseProperty("VISIO_MAPPING")]
        public virtual DIAGRAM_TYPES Specific_TypeNavigation { get; set; }
    }
}