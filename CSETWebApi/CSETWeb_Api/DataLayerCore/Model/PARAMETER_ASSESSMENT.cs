using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class PARAMETER_ASSESSMENT
    {
        public int Parameter_ID { get; set; }
        public int Assessment_ID { get; set; }
        public string Parameter_Value_Assessment { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual PARAMETERS Parameter_ { get; set; }
    }
}
