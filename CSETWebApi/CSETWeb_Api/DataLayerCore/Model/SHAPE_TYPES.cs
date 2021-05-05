using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class SHAPE_TYPES
    {
        [StringLength(50)]
        public string Diagram_Type_XML { get; set; }
        [Required]
        [StringLength(50)]
        public string Telerik_Shape_Type { get; set; }
        [Required]
        [StringLength(50)]
        public string Visio_Shape_Type { get; set; }
        public bool IsDefault { get; set; }
        [StringLength(50)]
        public string DisplayName { get; set; }
    }
}