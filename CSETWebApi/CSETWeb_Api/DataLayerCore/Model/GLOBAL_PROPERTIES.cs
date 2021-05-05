using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class GLOBAL_PROPERTIES
    {
        [StringLength(50)]
        public string Property { get; set; }
        [StringLength(7500)]
        public string Property_Value { get; set; }
    }
}