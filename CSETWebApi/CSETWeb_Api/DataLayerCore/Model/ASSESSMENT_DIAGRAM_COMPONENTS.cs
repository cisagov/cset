using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_DIAGRAM_COMPONENTS
    {
        public int Assessment_Id { get; set; }
        public Guid Component_Id { get; set; }
        [StringLength(100)]
        public string Diagram_Component_Type { get; set; }
        [StringLength(200)]
        public string label { get; set; }
        [StringLength(50)]
        public string DrawIO_id { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("ASSESSMENT_DIAGRAM_COMPONENTS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
    }
}