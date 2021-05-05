using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class CSET_VERSION
    {
        public int Id { get; set; }
        [Column(TypeName = "decimal(18, 4)")]
        public decimal Version_Id { get; set; }
        [Required]
        [Column("Cset_Version")]
        [StringLength(50)]
        public string Cset_Version1 { get; set; }
        [StringLength(500)]
        public string Build_Number { get; set; }
    }
}