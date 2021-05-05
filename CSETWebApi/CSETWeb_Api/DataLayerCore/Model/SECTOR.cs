using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
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
        [Required]
        [StringLength(50)]
        public string SectorName { get; set; }

        [InverseProperty("Sector")]
        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
        [InverseProperty("Sector")]
        public virtual ICollection<SECTOR_INDUSTRY> SECTOR_INDUSTRY { get; set; }
        [InverseProperty("Sector_")]
        public virtual ICollection<SECTOR_STANDARD_RECOMMENDATIONS> SECTOR_STANDARD_RECOMMENDATIONS { get; set; }
    }
}