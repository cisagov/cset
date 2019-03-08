using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class COMPONENT_QUESTIONS
    {
        public int Question_Id { get; set; }
        [StringLength(50)]
        public string Component_Type { get; set; }
        public int Weight { get; set; }
        public int Rank { get; set; }
        [StringLength(50)]
        public string Seq { get; set; }

        public virtual COMPONENT_SYMBOLS Component_TypeNavigation { get; set; }
        [ForeignKey("Question_Id")]
        [InverseProperty("COMPONENT_QUESTIONS")]
        public virtual NEW_QUESTION Question_ { get; set; }
    }
}