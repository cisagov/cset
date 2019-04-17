//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using static BusinessLogic.Models.ExternalRequirement;

namespace BusinessLogic.Models
{
    public interface IExternalRequirement
    {
        string Category { get; set; }
        [Required]
        string Identifier { get; set; }
        IEnumerable<ExternalResource> References { get; set; }
        [Required]
        int? SecurityAssuranceLevel { get; set; }
        ExternalResource Source { get; set; }
        [Required]
        string Heading { get; set; }
        [Required]
        string Subheading { get; set; }
        string Supplemental { get; set; }
        [Required]
        string Text { get; set; }
        [Required]
        int? Weight { get; set; }
        QuestionList Questions { get; set; }
    }
}

