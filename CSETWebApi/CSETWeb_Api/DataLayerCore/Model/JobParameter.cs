using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    [Table("JobParameter", Schema = "HangFire")]
    public partial class JobParameter
    {
        public int Id { get; set; }
        public int JobId { get; set; }
        [Required]
        [StringLength(40)]
        public string Name { get; set; }
        public string Value { get; set; }

        [ForeignKey("JobId")]
        [InverseProperty("JobParameter")]
        public virtual Job Job { get; set; }
    }
}
