using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class STANDARD_SPECIFIC_LEVEL
    {
        public STANDARD_SPECIFIC_LEVEL()
        {
            REQUIREMENT_LEVELS = new HashSet<REQUIREMENT_LEVELS>();
            STANDARD_TO_UNIVERSAL_MAP = new HashSet<STANDARD_TO_UNIVERSAL_MAP>();
        }

        public string Standard_Level { get; set; }
        public int Level_Order { get; set; }
        public string Full_Name { get; set; }
        public string Standard { get; set; }
        public string Display_Name { get; set; }
        public int? Display_Order { get; set; }
        public bool Is_Default_Value { get; set; }
        public bool Is_Mapping_Link { get; set; }

        public virtual ICollection<REQUIREMENT_LEVELS> REQUIREMENT_LEVELS { get; set; }
        public virtual ICollection<STANDARD_TO_UNIVERSAL_MAP> STANDARD_TO_UNIVERSAL_MAP { get; set; }
    }
}
