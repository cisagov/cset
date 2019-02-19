using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SECTOR_INDUSTRY
    {
        public SECTOR_INDUSTRY()
        {
            DEMOGRAPHICS = new HashSet<DEMOGRAPHICS>();
        }

        public int SectorId { get; set; }
        public int IndustryId { get; set; }
        public string IndustryName { get; set; }

        public virtual SECTOR Sector { get; set; }
        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
    }
}
