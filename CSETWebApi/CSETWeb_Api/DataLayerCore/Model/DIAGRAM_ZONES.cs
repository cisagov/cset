using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_ZONES
    {
        public DIAGRAM_ZONES()
        {
            ASSESSMENT_DIAGRAM_COMPONENTS = new HashSet<ASSESSMENT_DIAGRAM_COMPONENTS>();
        }

        [Key]
        public int Zone_Id { get; set; }
        [Required]
        [StringLength(250)]
        public string Zone_Name { get; set; }
        [Required]
        [StringLength(10)]
        public string Universal_Sal_Level { get; set; }
        [Required]
        [StringLength(50)]
        public string DrawIO_id { get; set; }
        public int Assessment_Id { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("DIAGRAM_ZONES")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [InverseProperty("Zone_")]
        public virtual ICollection<ASSESSMENT_DIAGRAM_COMPONENTS> ASSESSMENT_DIAGRAM_COMPONENTS { get; set; }
    }
}