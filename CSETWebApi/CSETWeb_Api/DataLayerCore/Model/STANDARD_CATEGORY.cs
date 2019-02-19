using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class STANDARD_CATEGORY
    {
        public STANDARD_CATEGORY()
        {
            NEW_REQUIREMENT = new HashSet<NEW_REQUIREMENT>();
            STANDARD_CATEGORY_SEQUENCE = new HashSet<STANDARD_CATEGORY_SEQUENCE>();
        }

        public string Standard_Category1 { get; set; }

        public virtual ICollection<NEW_REQUIREMENT> NEW_REQUIREMENT { get; set; }
        public virtual ICollection<STANDARD_CATEGORY_SEQUENCE> STANDARD_CATEGORY_SEQUENCE { get; set; }
    }
}
