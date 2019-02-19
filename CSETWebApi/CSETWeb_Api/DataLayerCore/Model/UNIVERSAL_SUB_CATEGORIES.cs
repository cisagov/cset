using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class UNIVERSAL_SUB_CATEGORIES
    {
        public UNIVERSAL_SUB_CATEGORIES()
        {
            UNIVERSAL_SUB_CATEGORY_HEADINGS = new HashSet<UNIVERSAL_SUB_CATEGORY_HEADINGS>();
        }

        public string Universal_Sub_Category { get; set; }
        public int Universal_Sub_Category_Id { get; set; }

        public virtual ICollection<UNIVERSAL_SUB_CATEGORY_HEADINGS> UNIVERSAL_SUB_CATEGORY_HEADINGS { get; set; }
    }
}
