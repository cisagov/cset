using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class SECTOR_STANDARD_RECOMMENDATIONS
    {
        public int Sector_Id { get; set; }
        public int Industry_Id { get; set; }
        [StringLength(50)]
        public string Organization_Size { get; set; }
        [StringLength(50)]
        public string Asset_Value { get; set; }
        [StringLength(50)]
        public string Set_Name { get; set; }

        [ForeignKey("Sector_Id")]
        [InverseProperty("SECTOR_STANDARD_RECOMMENDATIONS")]
        public virtual SECTOR Sector_ { get; set; }
        [ForeignKey("Set_Name")]
        [InverseProperty("SECTOR_STANDARD_RECOMMENDATIONS")]
        public virtual SETS Set_NameNavigation { get; set; }
    }
}