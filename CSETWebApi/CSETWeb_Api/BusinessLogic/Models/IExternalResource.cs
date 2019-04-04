//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.ComponentModel.DataAnnotations;

namespace BusinessLogic.Models
{
    public interface IExternalResource
    {
        string Destination { get; set; }
        [Required]
        string FileName { get; set; }
        int? PageNumber { get; set; }
    }
}

