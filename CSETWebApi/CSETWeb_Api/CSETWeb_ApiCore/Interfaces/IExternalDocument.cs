//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.Interfaces
{
    public interface IExternalDocument
    {
        [Required]
        string Name { get; set; }
        [Required]
        string ShortName { get; set; }
        byte[] Data { get; set; }
        double? FileSize { get; set; }
        string FileName { get; set; }
    }
}