using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    [Table("Set", Schema = "HangFire")]
    public partial class Set
    {
        public int Id { get; set; }
        [Required]
        [StringLength(100)]
        public string Key { get; set; }
        public double Score { get; set; }
        [Required]
        [StringLength(256)]
        public string Value { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? ExpireAt { get; set; }
    }
}
