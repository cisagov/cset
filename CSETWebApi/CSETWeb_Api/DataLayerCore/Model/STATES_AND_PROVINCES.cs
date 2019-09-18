using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class STATES_AND_PROVINCES
    {
        [Required]
        [StringLength(5)]
        public string ISO_code { get; set; }
        [Required]
        [StringLength(50)]
        public string Display_Name { get; set; }
        [Key]
        public int STATES_AND_PROVINCES_ID { get; set; }
        [StringLength(5)]
        public string Country_Code { get; set; }

        public virtual COUNTRIES Country_CodeNavigation { get; set; }
    }
}