using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class STANDARD_CATEGORY_SEQUENCE
    {
        public string Standard_Category { get; set; }
        public string Set_Name { get; set; }
        public int Standard_Category_Sequence1 { get; set; }

        public virtual SETS Set_NameNavigation { get; set; }
        public virtual STANDARD_CATEGORY Standard_CategoryNavigation { get; set; }
    }
}
