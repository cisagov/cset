using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NIST_SAL_INFO_TYPES_DEFAULTS
    {
        public string Type_Value { get; set; }
        public string Confidentiality_Value { get; set; }
        public string Confidentiality_Special_Factor { get; set; }
        public string Integrity_Value { get; set; }
        public string Integrity_Special_Factor { get; set; }
        public string Availability_Value { get; set; }
        public string Availability_Special_Factor { get; set; }
        public string Area { get; set; }
        public string NIST_Number { get; set; }
    }
}
