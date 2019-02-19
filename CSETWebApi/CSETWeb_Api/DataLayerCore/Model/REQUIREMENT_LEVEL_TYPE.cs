using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_LEVEL_TYPE
    {
        public REQUIREMENT_LEVEL_TYPE()
        {
            REQUIREMENT_LEVELS = new HashSet<REQUIREMENT_LEVELS>();
        }

        public string Level_Type { get; set; }
        public string Level_Type_Full_Name { get; set; }

        public virtual ICollection<REQUIREMENT_LEVELS> REQUIREMENT_LEVELS { get; set; }
    }
}
