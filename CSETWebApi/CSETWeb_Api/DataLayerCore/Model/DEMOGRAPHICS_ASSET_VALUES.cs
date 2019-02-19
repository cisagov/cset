using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DEMOGRAPHICS_ASSET_VALUES
    {
        public DEMOGRAPHICS_ASSET_VALUES()
        {
            DEMOGRAPHICS = new HashSet<DEMOGRAPHICS>();
        }

        public int DemographicsAssetId { get; set; }
        public string AssetValue { get; set; }
        public int? ValueOrder { get; set; }

        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
    }
}
