//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using NJsonSchema;
using NJsonSchema.Annotations;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using CSETWebCore.Interfaces;

namespace CSETWebCore.Model
{
    public class ExternalRequirement : IExternalRequirement
    {
        [Required]
        [DataMember]
        public string Identifier { get; set; }

        [Required]
        [DataMember]
        public string Text { get; set; }

        [Required]
        [DataMember]
        public string Heading { get; set; }

        [Required]
        [DataMember]
        public int? Weight { get; set; }

        [DataMember]
        public string Supplemental { get; set; }

        [DataMember]
        public string Category { get; set; }

        [Required]
        [DataMember]
        public string Subheading { get; set; }

        public string Subcategory { get; set; }

        [DataMember]
        public List<string> SecurityAssuranceLevels { get; set; }

        [DataMember]
        public ExternalResource Source { get; set; }

        [DataMember]
        public IEnumerable<ExternalResource> References { get; set; }

        [DataMember]
        [JsonSchema(JsonObjectType.Array, ArrayItem = typeof(string), Name = "Questions")]
        public QuestionList Questions { get; set; }

        [CollectionDataContract(Namespace = "", ItemName = "Question")]


        public class QuestionList : List<string>
        {

        }
    }
}