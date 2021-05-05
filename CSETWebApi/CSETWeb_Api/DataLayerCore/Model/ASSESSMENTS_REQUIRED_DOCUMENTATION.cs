using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class ASSESSMENTS_REQUIRED_DOCUMENTATION
    {
        public int Assessment_Id { get; set; }
        public int Documentation_Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Answer { get; set; }
        [StringLength(1024)]
        public string Comment { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("ASSESSMENTS_REQUIRED_DOCUMENTATION")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Documentation_Id")]
        [InverseProperty("ASSESSMENTS_REQUIRED_DOCUMENTATION")]
        public virtual REQUIRED_DOCUMENTATION Documentation_ { get; set; }
    }
}