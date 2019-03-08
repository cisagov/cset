using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class STANDARD_TO_UNIVERSAL_MAP
    {
        [StringLength(10)]
        public string Universal_Sal_Level { get; set; }
        [StringLength(50)]
        public string Standard_Level { get; set; }

        [ForeignKey("Standard_Level")]
        [InverseProperty("STANDARD_TO_UNIVERSAL_MAP")]
        public virtual STANDARD_SPECIFIC_LEVEL Standard_LevelNavigation { get; set; }
        [ForeignKey("Universal_Sal_Level")]
        [InverseProperty("STANDARD_TO_UNIVERSAL_MAP")]
        public virtual UNIVERSAL_SAL_LEVEL Universal_Sal_LevelNavigation { get; set; }
    }
}