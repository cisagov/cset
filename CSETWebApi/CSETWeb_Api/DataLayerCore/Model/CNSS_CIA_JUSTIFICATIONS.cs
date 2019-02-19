using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class CNSS_CIA_JUSTIFICATIONS
    {
        public int Assessment_Id { get; set; }
        public string CIA_Type { get; set; }
        public string DropDownValueLevel { get; set; }
        public string Justification { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual CNSS_CIA_TYPES CIA_TypeNavigation { get; set; }
    }
}
