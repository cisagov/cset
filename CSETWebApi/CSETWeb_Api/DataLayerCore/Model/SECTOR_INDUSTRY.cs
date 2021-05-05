using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class SECTOR_INDUSTRY
    {
        public SECTOR_INDUSTRY()
        {
            DEMOGRAPHICS = new HashSet<DEMOGRAPHICS>();
        }

        public int SectorId { get; set; }
        public int IndustryId { get; set; }
        [Required]
        [StringLength(150)]
        public string IndustryName { get; set; }

        [ForeignKey("SectorId")]
        [InverseProperty("SECTOR_INDUSTRY")]
        public virtual SECTOR Sector { get; set; }
        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
    }
}