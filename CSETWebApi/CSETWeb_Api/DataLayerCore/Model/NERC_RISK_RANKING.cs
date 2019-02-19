using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NERC_RISK_RANKING
    {
        public int? Question_id { get; set; }
        public int? Requirement_Id { get; set; }
        public int Compliance_Risk_Rank { get; set; }
        public string Violation_Risk_Factor { get; set; }

        public virtual NEW_QUESTION Question_ { get; set; }
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}
