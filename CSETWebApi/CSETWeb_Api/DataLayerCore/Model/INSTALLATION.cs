using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class INSTALLATION
    {
        [Key]
        [StringLength(200)]
        public string JWT_Secret { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime Generated_UTC { get; set; }
        [Required]
        [StringLength(200)]
        public string Installation_ID { get; set; }
    }
}