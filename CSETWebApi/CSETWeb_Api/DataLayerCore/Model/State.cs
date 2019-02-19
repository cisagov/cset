using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    [Table("State", Schema = "HangFire")]
    public partial class State
    {
        public int Id { get; set; }
        public int JobId { get; set; }
        [Required]
        [StringLength(20)]
        public string Name { get; set; }
        [StringLength(100)]
        public string Reason { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime CreatedAt { get; set; }
        public string Data { get; set; }

        [ForeignKey("JobId")]
        [InverseProperty("State")]
        public virtual Job Job { get; set; }
    }
}
