using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class SYMBOL_GROUPS
    {
        public int Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Symbol_Group_Name { get; set; }
        [Required]
        [StringLength(50)]
        public string Symbol_Group_Title { get; set; }
    }
}