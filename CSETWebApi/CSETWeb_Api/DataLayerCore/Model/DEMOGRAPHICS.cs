using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DEMOGRAPHICS
    {
        public DEMOGRAPHICS()
        {
            DOCUMENT_FILE = new HashSet<DOCUMENT_FILE>();
        }

        public int Assessment_Id { get; set; }
        public int? SectorId { get; set; }
        public int? IndustryId { get; set; }
        public string Size { get; set; }
        public string AssetValue { get; set; }
        public bool NeedsPrivacy { get; set; }
        public bool NeedsSupplyChain { get; set; }
        public bool NeedsICS { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual DEMOGRAPHICS_ASSET_VALUES AssetValueNavigation { get; set; }
        public virtual SECTOR_INDUSTRY Industry { get; set; }
        public virtual SECTOR Sector { get; set; }
        public virtual DEMOGRAPHICS_SIZE SizeNavigation { get; set; }
        public virtual ICollection<DOCUMENT_FILE> DOCUMENT_FILE { get; set; }
    }
}
