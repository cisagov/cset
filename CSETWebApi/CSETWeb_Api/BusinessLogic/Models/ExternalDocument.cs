//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace BusinessLogic.Models
{
    public class ExternalDocument : IExternalDocument
    {
        [Required]
        public string Name { get; set; }
        [Required]
        [MaxLength(40, ErrorMessage ="Document ShortName should be less than 40 characters")]
        public string ShortName { get; set; }
        public byte[] Data { get; set; }
        public double? FileSize { get; set; }
        public string FileName { get; set; }
    }
}

