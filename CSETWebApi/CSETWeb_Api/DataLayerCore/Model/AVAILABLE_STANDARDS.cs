using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class AVAILABLE_STANDARDS
    {
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public string Set_Name { get; set; }
        public bool Selected { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("AVAILABLE_STANDARDS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Set_Name")]
        [InverseProperty("AVAILABLE_STANDARDS")]
        public virtual SETS Set_NameNavigation { get; set; }
    }
}