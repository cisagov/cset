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
