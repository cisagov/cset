using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_SELECTED_LEVELS
    {
        public int Assessment_Id { get; set; }
        public string Level_Name { get; set; }
        public string Standard_Specific_Sal_Level { get; set; }

        public virtual STANDARD_SELECTION Assessment_ { get; set; }
        public virtual LEVEL_NAMES Level_NameNavigation { get; set; }
    }
}
