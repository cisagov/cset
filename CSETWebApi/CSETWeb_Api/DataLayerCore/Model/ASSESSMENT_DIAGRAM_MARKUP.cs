using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_DIAGRAM_MARKUP
    {
        public int Assessment_Id { get; set; }
        public int Diagram_Id { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("ASSESSMENT_DIAGRAM_MARKUP")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Diagram_Id")]
        [InverseProperty("ASSESSMENT_DIAGRAM_MARKUP")]
        public virtual DIAGRAM_MARKUP Diagram_ { get; set; }
    }
}