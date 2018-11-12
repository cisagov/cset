//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace BusinessLogic.Models
{
    [DataContract(Namespace = "", Name = "Resource")]
    public class ExternalResource : IExternalResource
    {
        [Required]
        [DataMember]
        public string FileName { get; set; }
        [DataMember]
        public int? PageNumber { get; set; }
        [DataMember]
        public string Destination { get; set; }
        [DataMember]
        public string SectionReference { get; set; }

    }
}

