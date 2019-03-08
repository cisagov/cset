using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class SECURITY_QUESTION
    {
        [Key]
        public int SecurityQuestionId { get; set; }
        [Required]
        [StringLength(500)]
        public string SecurityQuestion { get; set; }
        [Required]
        public bool? IsCustomQuestion { get; set; }
    }
}