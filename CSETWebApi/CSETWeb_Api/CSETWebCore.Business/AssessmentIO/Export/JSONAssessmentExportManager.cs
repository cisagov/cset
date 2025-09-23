//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Gallery;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Maturity;

namespace CSETWebCore.Business.AssessmentIO.Export
{
    public class JSONAssessmentExportManager
    {
        private readonly IAssessmentBusiness _assessmentBusiness;
        private readonly IContactBusiness _contactBusiness;
        private readonly IReportsDataBusiness _reportsDataBusiness;
        private readonly IQuestionBusiness _questionBusiness;
        private readonly JsonSerializerOptions _serializerOptions;

        /// <summary>
        /// Creates an export manager that uses the assessment business service to fetch
        /// detailed assessment data for JSON serialization.
        /// </summary>
        public JSONAssessmentExportManager(
            IAssessmentBusiness assessmentBusiness,
            IContactBusiness contactBusiness,
            IReportsDataBusiness reportsDataBusiness,
            IQuestionBusiness questionBusiness)
        {
            _assessmentBusiness = assessmentBusiness ?? throw new ArgumentNullException(nameof(assessmentBusiness));
            _contactBusiness = contactBusiness ?? throw new ArgumentNullException(nameof(contactBusiness));
            _reportsDataBusiness = reportsDataBusiness ?? throw new ArgumentNullException(nameof(reportsDataBusiness));
            _questionBusiness = questionBusiness ?? throw new ArgumentNullException(nameof(questionBusiness));
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
        public string GetJson(int assessmentId, bool removePCII = false)
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
            List<StandardQuestions> standardQuestions = null;
            QuestionResponse questionList = null;
            List<MatRelevantAnswers> maturityQuestions = null;
            List<ComponentQuestion> componentQuestions = null;

            var detailSections = new Dictionary<string, object>();

            // Standards-based assessment
            if (assessment.UseStandard)
            {
                // Ensure the standard selections are populated before exporting
                if (assessment.Standards == null || assessment.Standards.Count == 0)
                {
                    _assessmentBusiness.GetSelectedStandards(ref assessment);
                }

                _reportsDataBusiness.SetReportsAssessmentId(assessment.Id);
                standardQuestions = _reportsDataBusiness.GetQuestionsForEachStandard();

                // Fallback to question list for unanswered standards so export matches api/QuestionList
                if (standardQuestions == null || !standardQuestions.Any())
                {
                    _questionBusiness.SetQuestionAssessmentId(assessment.Id);
                    questionList = _questionBusiness.GetQuestionListWithSet("*");

                    if (questionList?.Categories != null)
                    {
                        var standardMap = new Dictionary<string, StandardQuestions>(StringComparer.OrdinalIgnoreCase);

                        foreach (var group in questionList.Categories)
                        {
                            var key = string.IsNullOrWhiteSpace(group.SetName) ? "STANDARD" : group.SetName;
                            if (!standardMap.TryGetValue(key, out var stdQuestions))
                            {
                                stdQuestions = new StandardQuestions
                                {
                                    StandardShortName = key,
                                    Questions = new List<SimpleStandardQuestions>()
                                };
                                standardMap[key] = stdQuestions;
                            }

                            foreach (var subCategory in group.SubCategories)
                            {
                                foreach (var question in subCategory.Questions)
                                {
                                    stdQuestions.Questions.Add(new SimpleStandardQuestions
                                    {
                                        ShortName = key,
                                        CategoryAndNumber = !string.IsNullOrWhiteSpace(question.DisplayNumber)
                                            ? $"{group.GroupHeadingText} #{question.DisplayNumber}"
                                            : group.GroupHeadingText,
                                        Question = question.QuestionText,
                                        QuestionId = question.QuestionId,
                                        Answer = question.Answer
                                    });
                                }
                            }
                        }

                        standardQuestions = standardMap.Values.Where(x => x.Questions.Any()).ToList();
                    }
                }

                detailSections["standardQuestions"] = standardQuestions;
                detailSections["questionList"] = questionList;
            }

            // Maturity model-based assessment
            if (assessment.UseMaturity)
            {
                _reportsDataBusiness.SetReportsAssessmentId(assessment.Id);
                maturityQuestions = _reportsDataBusiness.GetQuestionsList();

                detailSections["maturityQuestions"] = maturityQuestions;
            }

            // Network diagram-based assessment
            if (assessment.UseDiagram)
            {
                _reportsDataBusiness.SetReportsAssessmentId(assessment.Id);
                componentQuestions = _reportsDataBusiness.GetComponentQuestions() ?? new List<ComponentQuestion>();

                detailSections["componentQuestions"] = componentQuestions;
            }

            object details = detailSections.Count > 0 ? detailSections : null;

            // Remove PCII data if requested
            if (removePCII)
            {
                Console.WriteLine("Removed PCII from assessment export.");
            }

            CleanData(assessment);

            // Build out the full payload for serialization
            var payload = new
            {
                assessment,
                contacts,
                details
            };

            return JsonSerializer.Serialize(payload, _serializerOptions);
        }

        /// <summary>
        /// Removes export-only fields from the assessment payload to avoid leaking
        /// data that is not required by the exported JSON document.
        /// </summary>
        private void CleanData(AssessmentDetail assessment)
        {
            if (assessment == null)
            {
                return;
            }

            // Gallery selections are internal-only and should not be part of the export payload.
            assessment.GalleryItemGuid = null;

            if (!assessment.UseDiagram)
            {
                return;
            }

            // Network diagram exports should not include markup or rendered images.
            assessment.DiagramMarkup = null;
            assessment.DiagramImage = null;
        }
    }
}
