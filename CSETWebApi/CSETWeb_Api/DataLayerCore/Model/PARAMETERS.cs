using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class PARAMETERS
    {
        public PARAMETERS()
        {
            PARAMETER_ASSESSMENT = new HashSet<PARAMETER_ASSESSMENT>();
            PARAMETER_REQUIREMENTS = new HashSet<PARAMETER_REQUIREMENTS>();
            PARAMETER_VALUES = new HashSet<PARAMETER_VALUES>();
        }

        public int Parameter_ID { get; set; }
        public string Parameter_Name { get; set; }

        public virtual ICollection<PARAMETER_ASSESSMENT> PARAMETER_ASSESSMENT { get; set; }
        public virtual ICollection<PARAMETER_REQUIREMENTS> PARAMETER_REQUIREMENTS { get; set; }
        public virtual ICollection<PARAMETER_VALUES> PARAMETER_VALUES { get; set; }
    }
}
