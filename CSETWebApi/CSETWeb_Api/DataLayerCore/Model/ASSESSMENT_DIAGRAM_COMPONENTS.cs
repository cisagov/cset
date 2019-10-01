using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_DIAGRAM_COMPONENTS
    {
        public int Assessment_Id { get; set; }
        public Guid Component_Guid { get; set; }
        [StringLength(50)]
        public string Diagram_Component_Type { get; set; }
        [StringLength(200)]
        public string label { get; set; }
        [StringLength(50)]
        public string DrawIO_id { get; set; }
        public int? Zone_Id { get; set; }
        public int? Layer_Id { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("ASSESSMENT_DIAGRAM_COMPONENTS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual COMPONENT_SYMBOLS Diagram_Component_TypeNavigation { get; set; }
        [ForeignKey("Layer_Id")]
        [InverseProperty("ASSESSMENT_DIAGRAM_COMPONENTSLayer_")]
        public virtual DIAGRAM_CONTAINER Layer_ { get; set; }
        [ForeignKey("Zone_Id")]
        [InverseProperty("ASSESSMENT_DIAGRAM_COMPONENTSZone_")]
        public virtual DIAGRAM_CONTAINER Zone_ { get; set; }
    }
}