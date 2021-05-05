using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class SYMBOL_GROUPS
    {
        public SYMBOL_GROUPS()
        {
            COMPONENT_SYMBOLS = new HashSet<COMPONENT_SYMBOLS>();
        }

        public int Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Symbol_Group_Name { get; set; }
        [Required]
        [StringLength(50)]
        public string Symbol_Group_Title { get; set; }

        [InverseProperty("Symbol_Group_")]
        public virtual ICollection<COMPONENT_SYMBOLS> COMPONENT_SYMBOLS { get; set; }
    }
}