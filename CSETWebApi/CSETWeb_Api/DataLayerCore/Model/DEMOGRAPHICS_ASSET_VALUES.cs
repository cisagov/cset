using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DEMOGRAPHICS_ASSET_VALUES
    {
        public DEMOGRAPHICS_ASSET_VALUES()
        {
            DEMOGRAPHICS = new HashSet<DEMOGRAPHICS>();
        }

        public int DemographicsAssetId { get; set; }
        [Key]
        [StringLength(50)]
        public string AssetValue { get; set; }
        public int? ValueOrder { get; set; }

        [InverseProperty("AssetValueNavigation")]
        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
    }
}
