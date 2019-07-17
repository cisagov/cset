using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class COUNTRIES
    {
        [Required]
        [StringLength(5)]
        public string ISO_code { get; set; }
        [Required]
        [StringLength(58)]
        public string Display_Name { get; set; }
        [Key]
        public int COUNTRIES_ID { get; set; }
    }
}