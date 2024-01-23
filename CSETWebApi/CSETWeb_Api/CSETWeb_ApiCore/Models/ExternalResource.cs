//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using CSETWebCore.Interfaces;

namespace CSETWebCore.Model
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
