using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class NIST_SAL_QUESTION_ANSWERS
    {
        public int Assessment_Id { get; set; }
        public int Question_Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Question_Answer { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("NIST_SAL_QUESTION_ANSWERS")]
        public virtual STANDARD_SELECTION Assessment_ { get; set; }
        [ForeignKey("Question_Id")]
        [InverseProperty("NIST_SAL_QUESTION_ANSWERS")]
        public virtual NIST_SAL_QUESTIONS Question_ { get; set; }
    }
}
