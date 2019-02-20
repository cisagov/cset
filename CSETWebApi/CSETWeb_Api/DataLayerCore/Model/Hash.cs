using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    [Table("Hash", Schema = "HangFire")]
    public partial class Hash
    {
        public int Id { get; set; }
        [Required]
        [StringLength(100)]
        public string Key { get; set; }
        [Required]
        [StringLength(100)]
        public string Field { get; set; }
        public string Value { get; set; }
        public DateTime? ExpireAt { get; set; }
    }
}
