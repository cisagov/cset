//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////

using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.ExportJson;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace CSETWebCore.Business.AssessmentIO.Export
{
    public class JSONAssessmentExportManager
    {
        private readonly IAssessmentBusiness _assessmentBusiness;
        private readonly IContactBusiness _contactBusiness;
        private readonly IReportsDataBusiness _reportsDataBusiness;
        private readonly IQuestionBusiness _questionBusiness;
        private readonly CSETContext _context;
        private readonly JsonSerializerOptions _serializerOptions;

        /// <summary>
        /// Creates an export manager that uses the assessment business service to fetch
        /// detailed assessment data for JSON serialization.
        /// </summary>
        public JSONAssessmentExportManager(
            IAssessmentBusiness assessmentBusiness,
            IContactBusiness contactBusiness,
            IReportsDataBusiness reportsDataBusiness,
            IQuestionBusiness questionBusiness,
            CSETContext context)
        {
            _assessmentBusiness = assessmentBusiness ?? throw new ArgumentNullException(nameof(assessmentBusiness));
            _contactBusiness = contactBusiness ?? throw new ArgumentNullException(nameof(contactBusiness));
            _reportsDataBusiness = reportsDataBusiness ?? throw new ArgumentNullException(nameof(reportsDataBusiness));
            _questionBusiness = questionBusiness ?? throw new ArgumentNullException(nameof(questionBusiness));
            _context = context ?? throw new ArgumentNullException(nameof(context));
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
        public string GetJson(int assessmentId, string lang, bool removePCII = false)
        {
            if (assessmentId <= 0)
            {
                throw new ArgumentOutOfRangeException(nameof(assessmentId));
            }

            AssessmentDetail assessmentDetail = _assessmentBusiness.GetAssessmentDetail(assessmentId);

            if (assessmentDetail == null || assessmentDetail.Id == 0)
            {
                throw new InvalidOperationException($"Assessment {assessmentId} was not found.");
            }

            // Create JSON object
            var assessment = new AssessmentJson()
            {
                Id = assessmentDetail.Id,
                AssessmentDate = assessmentDetail.AssessmentDate,
                AssessmentGuid = assessmentDetail.AssessmentGuid,
                CreatedDate = assessmentDetail.CreatedDate,
                Name = assessmentDetail.AssessmentName,
                SelfAssessment = assessmentDetail.SelfAssessment
            };


            var contacts = _contactBusiness.GetContacts(assessmentId);
            List<StandardQuestions> standardQuestions = null;
            QuestionResponse questionList = null;
            List<ModelJson> maturityModels = null;
            List<ComponentQuestion> componentQuestions = null;
            SectorDetailsJson sectorDetails = null;


            var detailSections = new Dictionary<string, object>();



            // Standards-based assessment
            if (assessmentDetail.UseStandard)
            {
                // Ensure the standard selections are populated before exporting
                if (assessmentDetail.Standards == null || assessmentDetail.Standards.Count == 0)
                {
                    _assessmentBusiness.GetSelectedStandards(ref assessmentDetail);
                }

                _reportsDataBusiness.SetReportsAssessmentId(assessmentDetail.Id);
                standardQuestions = _reportsDataBusiness.GetQuestionsForEachStandard();

                // Fallback to question list for unanswered standards so export matches api/QuestionList
                if (standardQuestions == null || !standardQuestions.Any())
                {
                    _questionBusiness.SetQuestionAssessmentId(assessmentDetail.Id);
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
            if (assessmentDetail.UseMaturity)
            {
                var maturityBusiness = new MaturityBusiness(_context, null);
                var modelListJ = new List<ModelJson>();

                var modelIdList = GetApplicableModels(assessmentId);

                foreach (var modelId in modelIdList)
                {
                    // get the questions structure for the maturity model
                    MaturityResponse resp = new();
                    maturityBusiness.GetMaturityQuestions(assessmentId, false, 0, resp, modelId, lang);


                    var modelJ = new ModelJson
                    {
                        ModelId = modelId,
                        ModelTitle = resp.Title,
                        ModelName = resp.ModelName,
                        Levels = resp.Levels
                    };

                    modelListJ.Add(modelJ);


                    foreach (var r in resp.Groupings)
                    {
                        MapGrouping(modelJ.Groupings, r);
                    }
                }

                maturityModels = modelListJ;
            }


            // Network diagram-based assessment
            if (assessmentDetail.UseDiagram)
            {
                _reportsDataBusiness.SetReportsAssessmentId(assessmentDetail.Id);
                componentQuestions = _reportsDataBusiness.GetComponentQuestions() ?? new List<ComponentQuestion>();

                detailSections["componentQuestions"] = componentQuestions;
            }

            object details = detailSections.Count > 0 ? detailSections : null;

            // Build out the Sector details
            sectorDetails = BuildSectorDetails(assessmentDetail);

            // Remove irrelevant data from the payload
            CleanData(assessmentDetail);

            // Remove PCII data if requested
            if (removePCII)
            {
                RemovePCII(assessmentDetail);
            }

            // Build out the full payload for serialization
            var payload = new
            {
                assessment,
                sectorDetails,
                contacts,
                details,
                maturityModels
            };

            return JsonSerializer.Serialize(payload, _serializerOptions);
        }


        /// <summary>
        /// Recurse Groupings to populate the JSON classes
        /// </summary>
        private void MapGrouping(List<GroupingJson> groupingsJ, MaturityGrouping g)
        {
            var gj = new GroupingJson();
            groupingsJ.Add(gj);
            gj.GroupingId = g.GroupingId;
            gj.Title = g.Title;


            // child groupings
            foreach (MaturityGrouping subGroup in g.SubGroupings)
            {
                MapGrouping(gj.Groupings, subGroup);
            }

            if (g.SubGroupings.Count == 0)
            {
                gj.Groupings = null;
            }


            // questions within grouping
            foreach (var q in g.Questions)
            {
                var qJ = new MaturityQuestionJson();

                if (q.ParentQuestionId == null)
                {
                    qJ.QuestionText = q.QuestionText;
                    if (string.IsNullOrEmpty(qJ.QuestionText))
                    {
                        qJ.QuestionText = q.SecurityPractice;
                    }
                    qJ.QuestionId = q.QuestionId;
                    qJ.MaturityLevel = q.MaturityLevel;

                    if (q.IsAnswerable)
                    {
                        qJ.Answer = new();
                        qJ.Answer.AnswerText = q.Answer;
                        qJ.Answer.Comment = q.Comment;
                    }

                    gj.Questions.Add(qJ);
                }


                // look for child/followup questions
                var followups = g.Questions.Where(x => x.ParentQuestionId == q.QuestionId).ToList();

                foreach (var qq in followups)
                {
                    var qqJ = new MaturityQuestionJson();
                    qqJ.QuestionText = qq.QuestionText;
                    if (string.IsNullOrEmpty(qqJ.QuestionText))
                    {
                        qqJ.QuestionText = qq.SecurityPractice;
                    }

                    qqJ.QuestionId = qq.QuestionId;
                    qqJ.MaturityLevel = qq.MaturityLevel;

                    qqJ.Answer = new();
                    qqJ.Answer.AnswerText = qq.Answer;
                    qqJ.Answer.Comment = qq.Comment;

                    qJ.FollowupQuestions.Add(qqJ);

                    // assuming no followup-to-followup right now
                    qqJ.FollowupQuestions = null;
                }

                if (followups.Count == 0)
                {
                    qJ.FollowupQuestions = null;
                }
            }
        }


        /// <summary>
        /// Builds the sector details block for the export payload using the current assessment demographics.
        /// </summary>
        private SectorDetailsJson BuildSectorDetails(AssessmentDetail assessment)
        {
            if (assessment?.SectorId == null)
            {
                return null;
            }

            var sectorEntity = _context.SECTOR.FirstOrDefault(s => s.SectorId == assessment.SectorId.Value);
            if (sectorEntity == null)
            {
                return null;
            }

            int? selectedIndustryId = assessment.IndustryId;

            if (!selectedIndustryId.HasValue)
            {
                selectedIndustryId = _context.DETAILS_DEMOGRAPHICS
                    .Where(x => x.Assessment_Id == assessment.Id && x.DataItemName == "SUBSECTOR")
                    .Select(x => x.IntValue)
                    .FirstOrDefault();
            }

            var industriesQuery = _context.SECTOR_INDUSTRY.Where(x => x.SectorId == sectorEntity.SectorId);

            var selectedIndustryEntity = selectedIndustryId.HasValue
                ? industriesQuery.FirstOrDefault(x => x.IndustryId == selectedIndustryId.Value)
                : null;

            var exportDetails = new SectorDetailsJson
            {
                SectorId = sectorEntity.SectorId,
                SectorName = sectorEntity.SectorName,
            };

            if (selectedIndustryEntity != null)
            {
                exportDetails.SelectedIndustryId = selectedIndustryEntity.IndustryId;
                exportDetails.SelectedIndustryName = selectedIndustryEntity.IndustryName;
            }

            return exportDetails;
        }


        /// <summary>
        /// Removes export-only fields from the assessment payload to avoid leaking
        /// data that is not required by the exported JSON document.
        /// </summary>
        private static void CleanData(AssessmentDetail assessment)
        {
            if (assessment == null)
            {
                return;
            }

            // Remove fields from all assessment types
            assessment.Charter = null;
            assessment.GalleryItemGuid = null;

            // Remove fields specific to maturity-based assessments
            if (assessment.UseMaturity)
            {
                assessment.ApplicationMode = null;
            }

            // Remove fields specific to network diagram based assessments
            if (assessment.UseDiagram)
            {
                assessment.DiagramMarkup = null;
                assessment.DiagramImage = null;
            }
        }


        /// <summary>
        /// Removes PCII data from the assessment payload to avoid leaking sensitive
        /// information that is not required by the exported JSON document.
        /// </summary>
        private static void RemovePCII(AssessmentDetail assessment)
        {
            if (assessment == null)
            {
                return;
            }
            assessment.SectorId = null;
        }


        /// <summary>
        /// Determine which models are in scope for the assessment.
        /// The CompletionCounter class knows how to determine this.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        private List<int> GetApplicableModels(int assessmentId)
        {
            CompletionCounter cc = new(_context);
            return cc.DetermineInScopeModels(assessmentId).ToList();
        }
    }
}
