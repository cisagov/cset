using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SECTOR
    {
        public SECTOR()
        {
            DEMOGRAPHICS = new HashSet<DEMOGRAPHICS>();
            SECTOR_INDUSTRY = new HashSet<SECTOR_INDUSTRY>();
            SECTOR_STANDARD_RECOMMENDATIONS = new HashSet<SECTOR_STANDARD_RECOMMENDATIONS>();
        }

        public int SectorId { get; set; }
        public string SectorName { get; set; }

        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
        public virtual ICollection<SECTOR_INDUSTRY> SECTOR_INDUSTRY { get; set; }
        public virtual ICollection<SECTOR_STANDARD_RECOMMENDATIONS> SECTOR_STANDARD_RECOMMENDATIONS { get; set; }
    }
}
