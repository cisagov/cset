using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_IRP_HEADER
    {
        public int Assessment_Id { get; set; }
        public int IRP_Header_Id { get; set; }
        public int? Risk_Level { get; set; }
        [StringLength(500)]
        public string Comment { get; set; }
        public int? Header_Risk_Level_Id { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("ASSESSMENT_IRP_HEADER")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("IRP_Header_Id")]
        [InverseProperty("ASSESSMENT_IRP_HEADER")]
        public virtual IRP_HEADER IRP_Header_ { get; set; }
    }
}