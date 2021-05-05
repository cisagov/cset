using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class DEMOGRAPHICS
    {
        public DEMOGRAPHICS()
        {
            DOCUMENT_FILE = new HashSet<DOCUMENT_FILE>();
        }

        [Key]
        public int Assessment_Id { get; set; }
        public int? SectorId { get; set; }
        public int? IndustryId { get; set; }
        [StringLength(50)]
        public string Size { get; set; }
        [StringLength(50)]
        public string AssetValue { get; set; }
        public bool NeedsPrivacy { get; set; }
        public bool NeedsSupplyChain { get; set; }
        public bool NeedsICS { get; set; }
        public string OrganizationName { get; set; }
        public string Agency { get; set; }
        public int? OrganizationType { get; set; }
        public int? Facilitator { get; set; }
        public int? PointOfContact { get; set; }
        public bool? IsScoped { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("DEMOGRAPHICS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("AssetValue")]
        [InverseProperty("DEMOGRAPHICS")]
        public virtual DEMOGRAPHICS_ASSET_VALUES AssetValueNavigation { get; set; }
        public virtual SECTOR_INDUSTRY Industry { get; set; }
        [ForeignKey("SectorId")]
        [InverseProperty("DEMOGRAPHICS")]
        public virtual SECTOR Sector { get; set; }
        [ForeignKey("Size")]
        [InverseProperty("DEMOGRAPHICS")]
        public virtual DEMOGRAPHICS_SIZE SizeNavigation { get; set; }
        [ForeignKey(nameof(Facilitator))]
        [InverseProperty(nameof(ASSESSMENT_CONTACTS.DEMOGRAPHICSFacilitatorNavigation))]
        public virtual ASSESSMENT_CONTACTS FacilitatorNavigation { get; set; }
        [ForeignKey(nameof(OrganizationType))]
        [InverseProperty(nameof(DEMOGRAPHICS_ORGANIZATION_TYPE.DEMOGRAPHICS))]
        public virtual DEMOGRAPHICS_ORGANIZATION_TYPE OrganizationTypeNavigation { get; set; }
        [ForeignKey(nameof(PointOfContact))]
        [InverseProperty(nameof(ASSESSMENT_CONTACTS.DEMOGRAPHICSPointOfContactNavigation))]
        public virtual ASSESSMENT_CONTACTS PointOfContactNavigation { get; set; }
        [InverseProperty("Assessment_Navigation")]
        public virtual ICollection<DOCUMENT_FILE> DOCUMENT_FILE { get; set; }
        
    }
}