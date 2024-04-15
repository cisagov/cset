//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System.ComponentModel;

namespace CSETWebCore.Model.Assessment
{
    public class Demographics
    {
        public int AssessmentId { get; set; }
        public int? SectorId { get; set; }
        public int? IndustryId { get; set; }
        public int? Size { get; set; }
        public int? AssetValue { get; set; }
        public string OrganizationName { get; set; }
        public string Agency { get; set; }
        public int? OrganizationType { get; set; }
        public int? OrgPointOfContact { get; set; }
        public int? Facilitator { get; set; }
        public string CriticalService { get; set; }
        public int? PointOfContact { get; set; }
        public bool IsScoped { get; set; }

        [DisplayName("CISA Region")]
        public int? CisaRegion { get; set; }
    }
}
