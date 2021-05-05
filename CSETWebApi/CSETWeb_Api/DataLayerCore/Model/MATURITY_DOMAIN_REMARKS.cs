using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.DataLayer
{
    public partial class MATURITY_DOMAIN_REMARKS
    {
        
        public int Grouping_ID { get; set; }        
        public int Assessment_Id { get; set; }
        [Required]
        [StringLength(2048)]
        public string DomainRemarks { get; set; }

        [ForeignKey(nameof(Assessment_Id))]
        [InverseProperty(nameof(ASSESSMENTS.MATURITY_DOMAIN_REMARKS))]
        public virtual ASSESSMENTS Assessment { get; set; }
        [ForeignKey(nameof(Grouping_ID))]
        [InverseProperty(nameof(MATURITY_GROUPINGS.MATURITY_DOMAIN_REMARKS))]
        public virtual MATURITY_GROUPINGS Grouping { get; set; }
    }
}