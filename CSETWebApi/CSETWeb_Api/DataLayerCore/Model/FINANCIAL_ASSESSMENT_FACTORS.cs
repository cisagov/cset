using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_ASSESSMENT_FACTORS
    {
        public FINANCIAL_ASSESSMENT_FACTORS()
        {
            FINANCIAL_GROUPS = new HashSet<FINANCIAL_GROUPS>();
        }

        [Key]
        public int AssessmentFactorId { get; set; }
        [Required]
        [StringLength(255)]
        public string AssessmentFactor { get; set; }
        public int AssessmentFactorWeight { get; set; }

        [InverseProperty("AssessmentFactor")]
        public virtual ICollection<FINANCIAL_GROUPS> FINANCIAL_GROUPS { get; set; }
    }
}