using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class PARAMETER_ASSESSMENT
    {
        public int Parameter_ID { get; set; }
        public int Assessment_ID { get; set; }
        [Required]
        [StringLength(2000)]
        public string Parameter_Value_Assessment { get; set; }

        [ForeignKey("Assessment_ID")]
        [InverseProperty("PARAMETER_ASSESSMENT")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Parameter_ID")]
        [InverseProperty("PARAMETER_ASSESSMENT")]
        public virtual PARAMETERS Parameter_ { get; set; }
    }
}