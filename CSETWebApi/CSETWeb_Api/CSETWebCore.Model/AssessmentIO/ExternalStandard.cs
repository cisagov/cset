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


namespace CSETWebCore.Model.AssessmentIO
{
    [DataContract(Namespace = "", Name = "Standard")]
    [JsonSchemaProcessor(typeof(StandardSchemaProcessor))]

    public class ExternalStandard
    {

        public List<string> CustomStandards { get; set; }

        [Required]
        [DataMember]
        public string name { get; set; }

        [Required]
        [DataMember]
        [MaxLength(50)]
        public string shortName { get; set; }

        [Required]
        [DataMember]
        public string category { get; set; }

        [Required]
        [DataMember]
        public IEnumerable<ExternalRequirement> requirements { get; set; }

        [DataMember]
        public string summary { get; set; }

        

    }
}
