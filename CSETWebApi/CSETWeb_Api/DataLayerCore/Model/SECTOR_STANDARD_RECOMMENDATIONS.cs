using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SECTOR_STANDARD_RECOMMENDATIONS
    {
        public int Sector_Id { get; set; }
        public int Industry_Id { get; set; }
        public string Organization_Size { get; set; }
        public string Asset_Value { get; set; }
        public string Set_Name { get; set; }

        public virtual SECTOR Sector_ { get; set; }
        public virtual SETS Set_NameNavigation { get; set; }
    }
}
