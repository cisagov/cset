using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


namespace CSETWebCore.DataLayer
{
    public partial class ASSESSMENT_IRP
    {
        public int Answer_Id { get; set; }
        public int Assessment_Id { get; set; }
        public int IRP_Id { get; set; }
        public int? Response { get; set; }
        [StringLength(500)]
        public string Comment { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("ASSESSMENT_IRP")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("IRP_Id")]
        [InverseProperty("ASSESSMENT_IRP")]
        public virtual IRP IRP_ { get; set; }
    }
}