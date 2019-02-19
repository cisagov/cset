using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REPORT_OPTIONS_SELECTION
    {
        public int Assessment_Id { get; set; }
        public int Report_Option_Id { get; set; }
        public bool Is_Selected { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual REPORT_OPTIONS Report_Option_ { get; set; }
    }
}
