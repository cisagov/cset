//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.Interfaces.AssessmentIO
{
    public interface IExternalDocument
    {
        [Required]
        string name { get; set; }
        [Required]
        string shortName { get; set; }
        byte[] data { get; set; }
        double? fileSize { get; set; }
        string fileName { get; set; }
    }
}