using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_LEVELS
    {
        public int Requirement_Id { get; set; }
        public string Standard_Level { get; set; }
        public string Level_Type { get; set; }
        public int? Id { get; set; }

        public virtual REQUIREMENT_LEVEL_TYPE Level_TypeNavigation { get; set; }
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
        public virtual STANDARD_SPECIFIC_LEVEL Standard_LevelNavigation { get; set; }
    }
}
