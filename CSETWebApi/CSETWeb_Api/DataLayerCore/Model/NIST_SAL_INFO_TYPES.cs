using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NIST_SAL_INFO_TYPES
    {
        public int Assessment_Id { get; set; }
        public string Type_Value { get; set; }
        public bool Selected { get; set; }
        public string Confidentiality_Value { get; set; }
        public string Confidentiality_Special_Factor { get; set; }
        public string Integrity_Value { get; set; }
        public string Integrity_Special_Factor { get; set; }
        public string Availability_Value { get; set; }
        public string Availability_Special_Factor { get; set; }
        public string Area { get; set; }
        public string NIST_Number { get; set; }

        public virtual STANDARD_SELECTION Assessment_ { get; set; }
    }
}
