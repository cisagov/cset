using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class COMPONENT_NAMES_LEGACY
    {
        public int Component_Symbol_id { get; set; }
        [Key]
        [StringLength(50)]
        public string Old_Symbol_Name { get; set; }

        [ForeignKey("Component_Symbol_id")]
        [InverseProperty("COMPONENT_NAMES_LEGACY")]
        public virtual COMPONENT_SYMBOLS Component_Symbol_ { get; set; }
    }
}