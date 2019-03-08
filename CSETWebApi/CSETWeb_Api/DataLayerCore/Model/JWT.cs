using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class JWT
    {
        [Key]
        [StringLength(200)]
        public string Secret { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime Generated { get; set; }
    }
}