//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using NJsonSchema.Annotations;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using CSETWebCore.Interfaces;
using CSETWebCore.Model.AssessmentIO;

namespace CSETWebCore.Model
{
    [DataContract(Namespace = "", Name = "Standard")]
    [JsonSchemaProcessor(typeof(StandardSchemaProcessor))]

    public class ExternalStandard_DELETEME : IExternalStandard
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
