namespace CSETWebCore.Model.Analytics;

public class AgDemographics
{
    public int DemographicId { get; set; }
    public int? SectorId { get; set; }
    public int? IndustryId { get; set; }
    public string Size { get; set; }
    public string AssetValue { get; set; }
    public bool NeedsPrivacy { get; set; }
    public bool NeedsSupplyChain { get; set; }
    public bool NeedsIcs { get; set; }
    public string OrganizationName { get; set; }
    public string Agency { get; set; }
    public int? OrganizationType { get; set; }
    public int? Facilitator { get; set; }
    public int? PointOfContact { get; set; }
    public bool? IsScoped { get; set; }
    public string CriticalService { get; set; }
    public int AssessmentId { get; set; }
}