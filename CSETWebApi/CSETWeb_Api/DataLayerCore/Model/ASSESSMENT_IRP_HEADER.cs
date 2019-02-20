using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_IRP_HEADER
    {
        public int HEADER_RISK_LEVEL_ID { get; set; }
        public int ASSESSMENT_ID { get; set; }
        public int IRP_HEADER_ID { get; set; }
        public int? RISK_LEVEL { get; set; }

        [ForeignKey("ASSESSMENT_ID")]
        [InverseProperty("ASSESSMENT_IRP_HEADER")]
        public virtual ASSESSMENTS ASSESSMENT_ { get; set; }
        [ForeignKey("IRP_HEADER_ID")]
        [InverseProperty("ASSESSMENT_IRP_HEADER")]
        public virtual IRP_HEADER IRP_HEADER_ { get; set; }
    }
}
