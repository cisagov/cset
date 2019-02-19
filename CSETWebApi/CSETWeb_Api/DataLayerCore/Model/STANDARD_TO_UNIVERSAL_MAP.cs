using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class STANDARD_TO_UNIVERSAL_MAP
    {
        public string Universal_Sal_Level { get; set; }
        public string Standard_Level { get; set; }

        public virtual STANDARD_SPECIFIC_LEVEL Standard_LevelNavigation { get; set; }
        public virtual UNIVERSAL_SAL_LEVEL Universal_Sal_LevelNavigation { get; set; }
    }
}
