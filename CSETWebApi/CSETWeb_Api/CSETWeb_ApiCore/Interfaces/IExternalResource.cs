//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.Interfaces
{
    public interface IExternalResource
    {
        string Destination { get; set; }
        [Required]
        string FileName { get; set; }
        int? PageNumber { get; set; }
    }
}