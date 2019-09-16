using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_LAYERS
    {
        public DIAGRAM_LAYERS()
        {
            ASSESSMENT_DIAGRAM_COMPONENTS = new HashSet<ASSESSMENT_DIAGRAM_COMPONENTS>();
        }

        [Key]
        public int Layer_Id { get; set; }
        [Required]
        [StringLength(250)]
        public string Layer_Name { get; set; }
        [Required]
        public bool? Visible { get; set; }
        [Required]
        [StringLength(50)]
        public string DrawIO_id { get; set; }
        public int Assessment_Id { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("DIAGRAM_LAYERS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [InverseProperty("Layer_")]
        public virtual ICollection<ASSESSMENT_DIAGRAM_COMPONENTS> ASSESSMENT_DIAGRAM_COMPONENTS { get; set; }
    }
}