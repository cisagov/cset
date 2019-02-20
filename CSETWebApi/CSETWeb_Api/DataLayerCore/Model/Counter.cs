using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    [Table("Counter", Schema = "HangFire")]
    public partial class Counter
    {
        public int Id { get; set; }
        [Required]
        [StringLength(100)]
        public string Key { get; set; }
        public short Value { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? ExpireAt { get; set; }
    }
}
