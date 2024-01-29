//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using CSETWebCore.Model.AssessmentIO;


namespace CSETWebCore.Interfaces.AssessmentIO
{
    public interface IExternalRequirement
    {
        string category { get; set; }

        [Required]
        string identifier { get; set; }

        IEnumerable<ExternalResource> references { get; set; }

        [Required]
        List<string> securityAssuranceLevels { get; set; }

        ExternalResource source { get; set; }

        [Required]
        string heading { get; set; }

        [Required]
        string subheading { get; set; }

        string supplemental { get; set; }

        [Required]
        string text { get; set; }

        [Required]
        int? weight { get; set; }

        ExternalRequirement.QuestionList questions { get; set; }
    }
}