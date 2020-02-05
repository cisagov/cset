//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using NJsonSchema.Annotations;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace BusinessLogic.Models
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

