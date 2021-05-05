using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class COMPONENT_STANDARD_QUESTIONS
    {
        public int Question_Id { get; set; }
        public int Requirement_id { get; set; }
        [StringLength(50)]
        public string Component_Type { get; set; }

        public virtual COMPONENT_SYMBOLS Component_TypeNavigation { get; set; }
        [ForeignKey("Question_Id")]
        [InverseProperty("COMPONENT_STANDARD_QUESTIONS")]
        public virtual NEW_QUESTION Question_ { get; set; }
        [ForeignKey("Requirement_id")]
        [InverseProperty("COMPONENT_STANDARD_QUESTIONS")]
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}