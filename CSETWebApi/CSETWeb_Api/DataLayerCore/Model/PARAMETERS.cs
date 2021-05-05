using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class PARAMETERS
    {
        public PARAMETERS()
        {
            PARAMETER_ASSESSMENT = new HashSet<PARAMETER_ASSESSMENT>();
            PARAMETER_REQUIREMENTS = new HashSet<PARAMETER_REQUIREMENTS>();
            PARAMETER_VALUES = new HashSet<PARAMETER_VALUES>();
        }

        public int Parameter_ID { get; set; }
        [Required]
        [StringLength(350)]
        public string Parameter_Name { get; set; }

        [InverseProperty("Parameter_")]
        public virtual ICollection<PARAMETER_ASSESSMENT> PARAMETER_ASSESSMENT { get; set; }
        [InverseProperty("Parameter_")]
        public virtual ICollection<PARAMETER_REQUIREMENTS> PARAMETER_REQUIREMENTS { get; set; }
        [InverseProperty("Parameter_")]
        public virtual ICollection<PARAMETER_VALUES> PARAMETER_VALUES { get; set; }
    }
}