using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SETS_CATEGORY
    {
        public SETS_CATEGORY()
        {
            SETS = new HashSet<SETS>();
        }

        public int Set_Category_Id { get; set; }
        public string Set_Category_Name { get; set; }

        public virtual ICollection<SETS> SETS { get; set; }
    }
}
