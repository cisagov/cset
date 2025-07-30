//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using NJsonSchema.Annotations;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using System.Linq;


namespace CSETWebCore.Model.AssessmentIO
{
    [DataContract(Namespace = "", Name = "Standard")]
    [JsonSchemaProcessor(typeof(StandardSchemaProcessor))]

    public class ExternalStandard : IValidatableObject
    {

        public List<string> CustomStandards { get; set; }

        [Required(ErrorMessage = "Name is required.")]
        [DataMember]
        public string name { get; set; }

        [Required(ErrorMessage = "Short name is required.")]
        [DataMember]
        [MaxLength(50, ErrorMessage = "Short name cannot exceed 50 characters.")]
        public string shortName { get; set; }

        [Required(ErrorMessage = "Category is required.")]
        [DataMember]
        public string category { get; set; }

        [DataMember]
        public IEnumerable<ExternalRequirement> requirements { get; set; } = new List<ExternalRequirement>();

        [DataMember]
        public string summary { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            var results = new List<ValidationResult>();

            // Validate category format
            if (!string.IsNullOrWhiteSpace(category))
            {
                if (category.Length > 100)
                {
                    results.Add(new ValidationResult("Category name cannot exceed 100 characters.", new[] { nameof(category) }));
                }
            }

            // Validate shortName format (no special characters that could cause issues)
            if (!string.IsNullOrWhiteSpace(shortName))
            {
                if (shortName.Contains("/") || shortName.Contains("\\") || shortName.Contains("<") || shortName.Contains(">"))
                {
                    results.Add(new ValidationResult("Short name contains invalid characters. Avoid using /, \\, <, or >.", new[] { nameof(shortName) }));
                }
            }

            // Validate requirements structure
            if (requirements != null)
            {
                var reqList = requirements.ToList();
                for (int i = 0; i < reqList.Count; i++)
                {
                    var req = reqList[i];
                    if (req == null)
                    {
                        results.Add(new ValidationResult($"Requirement at index {i} is null.", new[] { $"requirements[{i}]" }));
                        continue;
                    }

                    if (string.IsNullOrWhiteSpace(req.identifier))
                    {
                        results.Add(new ValidationResult($"Requirement at index {i} has no identifier.", new[] { $"requirements[{i}].identifier" }));
                    }

                    if (string.IsNullOrWhiteSpace(req.text))
                    {
                        results.Add(new ValidationResult($"Requirement at index {i} has no text.", new[] { $"requirements[{i}].text" }));
                    }
                }
            }

            return results;
        }

    }
}
