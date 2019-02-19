using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REPORT_DETAIL_SECTION_SELECTION
    {
        public int Assessment_Id { get; set; }
        public int Report_Section_Id { get; set; }
        public int Report_Section_Order { get; set; }
        public bool Is_Selected { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual REPORT_DETAIL_SECTIONS Report_Section_ { get; set; }
    }
}
