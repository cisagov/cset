using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_MARKUP
    {
        public DIAGRAM_MARKUP()
        {
            ASSESSMENT_DIAGRAM_MARKUP = new HashSet<ASSESSMENT_DIAGRAM_MARKUP>();
        }

        [Key]
        public int Diagram_ID { get; set; }
        [Column(TypeName = "text")]
        public string Markup { get; set; }

        [InverseProperty("Diagram_")]
        public virtual ICollection<ASSESSMENT_DIAGRAM_MARKUP> ASSESSMENT_DIAGRAM_MARKUP { get; set; }
    }
}