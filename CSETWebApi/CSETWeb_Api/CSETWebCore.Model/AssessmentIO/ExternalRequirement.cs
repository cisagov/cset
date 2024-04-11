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


namespace CSETWebCore.Model.AssessmentIO
{
    public class ExternalRequirement
    {
        [Required]
        [DataMember]
        public string identifier { get; set; }

        [Required]
        [DataMember]
        public string text { get; set; }

        [Required]
        [DataMember]
        public string heading { get; set; }

        [Required]
        [DataMember]
        public int? weight { get; set; }

        [DataMember]
        public string supplemental { get; set; }

        [DataMember]
        public string category { get; set; }

        [Required]
        [DataMember]
        public string subheading { get; set; }

        public string subcategory { get; set; }

        [DataMember]
        public List<string> securityAssuranceLevels { get; set; }

        [DataMember]
        public ExternalResource source { get; set; }

        [DataMember]
        public IEnumerable<ExternalResource> references { get; set; }

        [DataMember]
        [JsonSchema(JsonObjectType.Array, ArrayItem = typeof(string), Name = "Questions")]
        public QuestionList questions { get; set; }

        [CollectionDataContract(Namespace = "", ItemName = "Question")]


        public class QuestionList : List<string>
        {

        }
    }
}