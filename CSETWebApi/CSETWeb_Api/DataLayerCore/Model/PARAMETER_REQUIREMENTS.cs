using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class PARAMETER_REQUIREMENTS
    {
        public int Requirement_Id { get; set; }
        public int Parameter_Id { get; set; }
        public int? ID { get; set; }

        public virtual PARAMETERS Parameter_ { get; set; }
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}
