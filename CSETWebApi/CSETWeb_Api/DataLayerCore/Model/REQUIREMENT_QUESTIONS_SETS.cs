using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_QUESTIONS_SETS
    {
        public int Question_Id { get; set; }
        public int Requirement_Id { get; set; }
        [StringLength(50)]
        public string Set_Name { get; set; }

        [ForeignKey("Question_Id")]
        [InverseProperty("REQUIREMENT_QUESTIONS_SETS")]
        public virtual NEW_QUESTION Question_ { get; set; }
        [ForeignKey("Requirement_Id")]
        [InverseProperty("REQUIREMENT_QUESTIONS_SETS")]
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
        [ForeignKey("Set_Name")]
        [InverseProperty("REQUIREMENT_QUESTIONS_SETS")]
        public virtual SETS Set_NameNavigation { get; set; }
    }
}
