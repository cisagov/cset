using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class REQUIREMENT_QUESTIONS
    {
        public int Question_Id { get; set; }
        public int Requirement_Id { get; set; }

        [ForeignKey("Question_Id")]
        [InverseProperty("REQUIREMENT_QUESTIONS")]
        public virtual NEW_QUESTION Question_ { get; set; }
        [ForeignKey("Requirement_Id")]
        [InverseProperty("REQUIREMENT_QUESTIONS")]
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}