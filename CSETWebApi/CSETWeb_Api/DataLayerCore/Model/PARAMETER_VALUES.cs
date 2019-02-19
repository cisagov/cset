using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class PARAMETER_VALUES
    {
        public int Answer_Id { get; set; }
        public int Parameter_Id { get; set; }
        public string Parameter_Value { get; set; }
        public bool Parameter_Is_Default { get; set; }

        public virtual ANSWER Answer_ { get; set; }
        public virtual PARAMETERS Parameter_ { get; set; }
    }
}
