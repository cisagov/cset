//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////

using System;
using System.Text.Json;
using System.Text.Json.Serialization;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Business.AssessmentIO.Export
{
    public class JSONAssessmentExportManager
    {
        private readonly IAssessmentBusiness _assessmentBusiness;
        private readonly IContactBusiness _contactBusiness;
        private readonly JsonSerializerOptions _serializerOptions;

        /// <summary>
        /// Creates an export manager that uses the assessment business service to fetch
        /// detailed assessment data for JSON serialization.
        /// </summary>
        public JSONAssessmentExportManager(IAssessmentBusiness assessmentBusiness, IContactBusiness contactBusiness)
        {
            _assessmentBusiness = assessmentBusiness ?? throw new ArgumentNullException(nameof(assessmentBusiness));
            _contactBusiness = contactBusiness ?? throw new ArgumentNullException(nameof(contactBusiness));
            _serializerOptions = new JsonSerializerOptions
            {
                WriteIndented = true,
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
            };
        }

        /// <summary>
        /// Returns the assessment details serialized as JSON for the supplied assessment id.
        /// </summary>
        public string GetJson(int assessmentId)
        {
            if (assessmentId <= 0)
            {
                throw new ArgumentOutOfRangeException(nameof(assessmentId));
            }

            AssessmentDetail assessment = _assessmentBusiness.GetAssessmentDetail(assessmentId);

            if (assessment == null || assessment.Id == 0)
            {
                throw new InvalidOperationException($"Assessment {assessmentId} was not found.");
            }

            var contacts = _contactBusiness.GetContacts(assessmentId);

            var payload = new
            {
                assessment,
                contacts
            };

            return JsonSerializer.Serialize(payload, _serializerOptions);
        }
    }
}
