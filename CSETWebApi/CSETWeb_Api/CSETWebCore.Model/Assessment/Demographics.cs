//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System.ComponentModel;

namespace CSETWebCore.Model.Assessment
{
    public class Demographics
    {
        public int AssessmentId { get; set; }


        /// <summary>
        /// Indicates which set of sector values to use:  PPD-21 or NIPP
        /// </summary>
        public string? SectorDirective { get; set; }

        public int? SectorId { get; set; }
        public int? IndustryId { get; set; }


        public int? Size { get; set; }
        public int? AssetValue { get; set; }
        public string OrganizationName { get; set; }
        public string? Agency { get; set; }
        public int? OrganizationType { get; set; }
        public int? OrgPointOfContact { get; set; }
        public int? FacilitatorId { get; set; }

        /// <summary>
        /// The technology domain for the assessment, e.g., OT, IT or OT+IT
        /// </summary>
        public string TechDomain { get; set; }

        public bool SelfAssessment { get; set; }
        public string? CriticalService { get; set; }
        public int? PointOfContact { get; set; }
        public bool? IsScoped { get; set; }

        [DisplayName("CISA Region")]
        public int? CisaRegion { get; set; }
    }
}
