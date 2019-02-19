using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REPORT_OPTIONS_SELECTION
    {
        public int Assessment_Id { get; set; }
        public int Report_Option_Id { get; set; }
        public bool Is_Selected { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("REPORT_OPTIONS_SELECTION")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Report_Option_Id")]
        [InverseProperty("REPORT_OPTIONS_SELECTION")]
        public virtual REPORT_OPTIONS Report_Option_ { get; set; }
    }
}
