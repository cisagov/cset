using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class SP80053_FAMILY_ABBREVIATIONS
    {
        [StringLength(2)]
        public string ID { get; set; }
        [Required]
        [StringLength(250)]
        public string Standard_Category { get; set; }
        public int Standard_Order { get; set; }
    }
}
