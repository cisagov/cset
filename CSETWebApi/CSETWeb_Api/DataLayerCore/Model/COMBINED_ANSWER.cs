using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class COMBINED_ANSWER
    {
        public COMBINED_ANSWER()
        {
            COMBINED_DOCUMENT_ANSWERS = new HashSet<COMBINED_DOCUMENT_ANSWERS>();
        }

        [Key]
        public int AnswerID { get; set; }
        public bool? Mark_For_Review { get; set; }
        [Column(TypeName = "ntext")]
        public string Comment { get; set; }
        [Column(TypeName = "ntext")]
        public string Alternate_Justification { get; set; }
        public int Question_Or_Requirement_Id { get; set; }
        [StringLength(36)]
        public string Custom_Question_Guid { get; set; }
        public int Component_Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Answer_Text { get; set; }
        [StringLength(36)]
        public string Component_Guid { get; set; }
        public bool Is_Component { get; set; }
        public bool? Is_Resolved { get; set; }
        public int Type_Question { get; set; }
        public Guid Merge_ID { get; set; }

        [InverseProperty("Answer")]
        public virtual ICollection<COMBINED_DOCUMENT_ANSWERS> COMBINED_DOCUMENT_ANSWERS { get; set; }
    }
}