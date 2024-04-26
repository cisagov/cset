using System;
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.Model.Analytics;

public class AgAssessment
{
    public int AssessmentId { get; set; }
    public Guid AssessmentGuid { get; set; }
    public DateTime AssessmentCreatedDate { get; set; }
    public DateTime? LastModifiedDate { get; set; }
    public string Alias { get; set; }
    public DateTime AssessmentDate { get; set; }
    public string CreditUnionName { get; set; }
    public string Charter { get; set; }
    public string Assets { get; set; }
    public int? IrptotalOverride { get; set; }
    public string IrptotalOverrideReason { get; set; }
    public bool MatDetailTargetBandOnly { get; set; }
    public string DiagramMarkup { get; set; }
    public int LastUsedComponentNumber { get; set; }
    public string DiagramImage { get; set; }
    public bool AnalyzeDiagram { get; set; }
    public bool UseDiagram { get; set; }
    public bool UseStandard { get; set; }
    public bool UseMaturity { get; set; }
    public DateTime? AssessmentEffectiveDate { get; set; }
    public Guid? GalleryItemGuid { get; set; }
    public bool? IseStateLed { get; set; }
    public string PciiNumber { get; set; }
    public bool IsPcii { get; set; }
}