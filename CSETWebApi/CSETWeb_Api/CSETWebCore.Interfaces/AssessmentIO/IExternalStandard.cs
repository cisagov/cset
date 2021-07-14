using CSETWebCore.Model.AssessmentIO;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;


namespace CSETWebCore.Interfaces.AssessmentIO
{
    public interface IExternalStandard
    {
        [Required]
        string Category { get; set; }
        [Required]
        string Name { get; set; }
        [Required]
        IEnumerable<ExternalRequirement> Requirements { get; set; }
        [Required]
        string ShortName { get; set; }
        string Summary { get; set; }
    }
}