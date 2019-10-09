using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ANSWER
    {
        public ANSWER()
        {
            DOCUMENT_ANSWERS = new HashSet<DOCUMENT_ANSWERS>();
            FINDING = new HashSet<FINDING>();
            PARAMETER_VALUES = new HashSet<PARAMETER_VALUES>();
        }

        public int Assessment_Id { get; set; }
        public int Answer_Id { get; set; }
        public bool Is_Requirement { get; set; }
        public int Question_Or_Requirement_Id { get; set; }
        public bool? Mark_For_Review { get; set; }
        [StringLength(2048)]
        public string Comment { get; set; }
        [StringLength(2048)]
        public string Alternate_Justification { get; set; }
        public int? Question_Number { get; set; }
        [Required]
        [StringLength(50)]
        public string Answer_Text { get; set; }
        public Guid Component_Guid { get; set; }
        public bool Is_Component { get; set; }
        [StringLength(50)]
        public string Custom_Question_Guid { get; set; }
        public bool Is_Framework { get; set; }
        public int? Old_Answer_Id { get; set; }
        public bool Reviewed { get; set; }
        [StringLength(2048)]
        public string FeedBack { get; set; }

        [ForeignKey("Answer_Text")]
        [InverseProperty("ANSWER")]
        public virtual ANSWER_LOOKUP Answer_TextNavigation { get; set; }
        [ForeignKey("Assessment_Id")]
        [InverseProperty("ANSWER")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [InverseProperty("Answer_")]
        public virtual ICollection<DOCUMENT_ANSWERS> DOCUMENT_ANSWERS { get; set; }
        [InverseProperty("Answer_")]
        public virtual ICollection<FINDING> FINDING { get; set; }
        [InverseProperty("Answer_")]
        public virtual ICollection<PARAMETER_VALUES> PARAMETER_VALUES { get; set; }
    }
}