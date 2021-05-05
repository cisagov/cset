using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class NAVIGATION_STATE
    {
        [Key]
        [StringLength(500)]
        public string Name { get; set; }
        public bool IsActive { get; set; }
        public bool IsError { get; set; }
        public bool IsVisited { get; set; }
        [Required]
        public bool? IsAvailable { get; set; }
        public double PercentCompletion { get; set; }
    }
}