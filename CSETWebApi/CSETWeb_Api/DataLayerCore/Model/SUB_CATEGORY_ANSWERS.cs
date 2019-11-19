using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class SUB_CATEGORY_ANSWERS
    {
        public int Assessement_Id { get; set; }
        public int Heading_Pair_Id { get; set; }
        public bool Is_Component { get; set; }
        public bool Is_Override { get; set; }
        [Required]
        [StringLength(50)]
        public string Answer_Text { get; set; }
        [StringLength(36)]
        public string Component_Guid { get; set; }

        [ForeignKey("Answer_Text")]
        [InverseProperty("SUB_CATEGORY_ANSWERS")]
        public virtual ANSWER_LOOKUP Answer_TextNavigation { get; set; }
        [ForeignKey("Assessement_Id")]
        [InverseProperty("SUB_CATEGORY_ANSWERS")]
        public virtual ASSESSMENTS Assessement_ { get; set; }
        public virtual UNIVERSAL_SUB_CATEGORY_HEADINGS Heading_Pair_ { get; set; }
    }
}