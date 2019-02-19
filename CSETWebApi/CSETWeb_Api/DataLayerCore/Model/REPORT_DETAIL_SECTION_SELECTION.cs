using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REPORT_DETAIL_SECTION_SELECTION
    {
        public int Assessment_Id { get; set; }
        public int Report_Section_Id { get; set; }
        public int Report_Section_Order { get; set; }
        public bool Is_Selected { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("REPORT_DETAIL_SECTION_SELECTION")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Report_Section_Id")]
        [InverseProperty("REPORT_DETAIL_SECTION_SELECTION")]
        public virtual REPORT_DETAIL_SECTIONS Report_Section_ { get; set; }
    }
}
