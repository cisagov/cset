using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class LEVEL_NAMES
    {
        public LEVEL_NAMES()
        {
            ASSESSMENT_SELECTED_LEVELS = new HashSet<ASSESSMENT_SELECTED_LEVELS>();
        }

        public string Level_Name { get; set; }

        public virtual ICollection<ASSESSMENT_SELECTED_LEVELS> ASSESSMENT_SELECTED_LEVELS { get; set; }
    }
}
