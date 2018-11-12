//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.Helpers;
using NJsonSchema.Annotations;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace BusinessLogic.Models
{
    [DataContract(Namespace = "",Name ="Standard")]
    [JsonSchemaProcessor(typeof(StandardSchemaProcessor))]

    public class ExternalStandard : IExternalStandard
    {
        [Required]
        [DataMember]
        public string Name { get; set; }
        [Required]
        [DataMember]
        [MaxLength(50)]
        public string ShortName { get; set; }
        [Required]
        [DataMember]
        public string Category { get; set; }
        [Required]
        [DataMember]
        public IEnumerable<ExternalRequirement> Requirements { get; set; }
        [DataMember]
        public string Summary { get; set; }
    }
}

