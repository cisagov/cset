//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////
using CSETWebCore.Business.Demographic;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Reports;
using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.ExportJson;
using CSETWebCore.Model.Maturity;
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
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IQuestionRequirementManager _questionRequirement;
        private readonly ITokenManager _tokenManager;
        private readonly ICisDemographicBusiness _cisDemographicBusiness;
        private readonly CSETContext _context;
        private readonly JsonSerializerOptions _serializerOptions;

        private List<ObservationJson> _answerObservations;
        private List<ObservationJson> _assessmentObservations;

        /// <summary>
        /// Creates an export manager that uses the assessment business service to fetch
        /// detailed assessment data for JSON serialization.
        /// </summary>
        public JSONAssessmentExportManager(
            IAssessmentBusiness assessmentBusiness,
            IContactBusiness contactBusiness,
            IReportsDataBusiness reportsDataBusiness,
            IQuestionBusiness questionBusiness,
            IAssessmentUtil assessmentUtil,
            IQuestionRequirementManager questionRequirement,
            ITokenManager tokenManager,
            ICisDemographicBusiness cisDemographicBusiness,
            CSETContext context)
        {
            _assessmentBusiness = assessmentBusiness ?? throw new ArgumentNullException(nameof(assessmentBusiness));
            _contactBusiness = contactBusiness ?? throw new ArgumentNullException(nameof(contactBusiness));
            _reportsDataBusiness = reportsDataBusiness ?? throw new ArgumentNullException(nameof(reportsDataBusiness));
            _questionBusiness = questionBusiness ?? throw new ArgumentNullException(nameof(questionBusiness));
            _assessmentUtil = assessmentUtil ?? throw new ArgumentNullException(nameof(assessmentUtil));
            _questionRequirement = questionRequirement ?? throw new ArgumentNullException(nameof(questionRequirement));
            _tokenManager = tokenManager ?? throw new ArgumentNullException(nameof(tokenManager));
            _cisDemographicBusiness = cisDemographicBusiness ?? throw new ArgumentNullException(nameof(cisDemographicBusiness));
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
                SelfAssessment = assessmentDetail.SelfAssessment,
                FacilitatorName = assessmentDetail.FacilitatorName,
                AssessorWorkflow = assessmentDetail.AssessorMode,
                OrganizationInfo = BuildOrgDetails(assessmentDetail)
            };


            var contacts = _contactBusiness.GetContacts(assessmentId);
            StandardsJson standards = null;
            List<ModelJson> maturityModels = null;
            List<ComponentQuestion> componentQuestions = null;


            var detailSections = new Dictionary<string, object>();

            GetObservations(assessmentId);

            assessment.Observations = _assessmentObservations;

            // Build CIS demographics
            var cisDemographics = BuildCisDemographics(assessmentId);

            // Standards-based assessment
            if (assessmentDetail.UseStandard)
            {
                // SAL
                var biz = new SalBusiness(_context, null, _assessmentUtil, null, null);
                var salInfo = biz.GetSals(assessmentId);
                assessment.Sal = new SalJson();
                assessment.Sal.OverallLevel = salInfo.Selected_Sal_Level;
                assessment.Sal.Methodology = salInfo.Methodology ?? "Simple";


                // Ensure the standard selections are populated before exporting
                if (assessmentDetail.Standards == null || assessmentDetail.Standards.Count == 0)
                {
                    _assessmentBusiness.GetSelectedStandards(ref assessmentDetail);
                }

                // Build standards export using new DTO structure
                standards = BuildStandardsJson(assessmentId, lang);
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
                contacts,
                cisDemographics,
                standards,
                details = detailSections.Count > 0 ? detailSections : null,
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

                    // Add observations if they exist for this answer
                    var myObs = _answerObservations.Where(x => x.AnswerId == q.Answer_Id).ToList();
                    foreach (var obs in myObs)
                    {
                        qJ.Observations.Add(obs);
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



                    // Add observations if they exist for this answer
                    var myObs = _answerObservations.Where(x => x.AnswerId == qq.Answer_Id).ToList();
                    foreach (var obs in myObs)
                    {
                        qqJ.Observations.Add(obs);
                    }

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


        /// <summary>
        /// Gets the application mode for standards (Questions or Requirements mode).
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns>Application mode string (e.g., "Questions", "Requirements")</returns>
        private string GetStandardsApplicationMode(int assessmentId)
        {
            var mode = _context.STANDARD_SELECTION
                .Where(x => x.Assessment_Id == assessmentId)
                .Select(x => x.Application_Mode)
                .FirstOrDefault();

            // Default to Questions mode if not set
            if (string.IsNullOrWhiteSpace(mode))
            {
                return "Questions";
            }

            // Normalize the mode to either "Questions" or "Requirements"
            return mode.Trim().StartsWith("Q", StringComparison.OrdinalIgnoreCase)
                ? "Questions"
                : "Requirements";
        }


        /// <summary>
        /// Builds the StandardsJson export object based on the assessment's application mode.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="lang"></param>
        /// <returns>StandardsJson containing either Questions or Requirements mode data</returns>
        private StandardsJson BuildStandardsJson(int assessmentId, string lang)
        {
            var mode = GetStandardsApplicationMode(assessmentId);

            if (mode == "Questions")
            {
                return BuildQuestionsMode(assessmentId, lang);
            }
            else
            {
                return BuildRequirementsMode(assessmentId, lang);
            }
        }


        /// <summary>
        /// Builds StandardsJson for Questions mode.
        /// </summary>
        private StandardsJson BuildQuestionsMode(int assessmentId, string lang)
        {
            // Initialize QuestionRequirementManager for this assessment
            _questionRequirement.InitializeManager(assessmentId);

            // Initialize QuestionBusiness to get questions
            _questionBusiness.SetQuestionAssessmentId(assessmentId);
            var questionResponse = _questionBusiness.GetQuestionListWithSet("*");

            var standardsJson = new StandardsJson
            {
                Mode = "Questions",
                Questions = new List<StandardQuestionSubCategoryJson>()
            };

            // Return empty structure if no questions found
            if (questionResponse == null || questionResponse.Categories == null)
            {
                return standardsJson;
            }

            // Map questions from QuestionResponse to StandardQuestionJson grouped by subcategory
            foreach (var category in questionResponse.Categories)
            {
                if (category.SubCategories == null) continue;

                foreach (var subCategory in category.SubCategories)
                {
                    if (subCategory.Questions == null || subCategory.Questions.Count == 0) continue;

                    var subCategoryJson = new StandardQuestionSubCategoryJson
                    {
                        SubCategory = subCategory.SubCategoryHeadingText,
                        Questions = new List<StandardQuestionJson>()
                    };

                    foreach (var question in subCategory.Questions)
                    {
                        var standardQuestion = new StandardQuestionJson
                        {
                            QuestionId = question.QuestionId,
                            QuestionText = question.QuestionText,
                            Title = question.DisplayNumber
                        };

                        // Add answer if present
                        if (!string.IsNullOrWhiteSpace(question.Answer) ||
                            !string.IsNullOrWhiteSpace(question.Comment) ||
                            question.Answer_Id.HasValue)
                        {
                            standardQuestion.Answer = new AnswerJson
                            {
                                AnswerText = question.Answer,
                                Comment = question.Comment
                            };

                            // Add observations if they exist for this answer
                            var myObs = _answerObservations.Where(x => x.AnswerId == question.Answer_Id).ToList();
                            foreach (var obs in myObs)
                            {
                                standardQuestion.Observations.Add(obs);
                            }
                        }

                        subCategoryJson.Questions.Add(standardQuestion);
                    }

                    standardsJson.Questions.Add(subCategoryJson);
                }
            }

            return standardsJson;
        }


        /// <summary>
        /// Builds StandardsJson for Requirements mode.
        /// </summary>
        private StandardsJson BuildRequirementsMode(int assessmentId, string lang)
        {
            // Initialize QuestionRequirementManager for this assessment
            _questionRequirement.InitializeManager(assessmentId);

            // Get requirements using RequirementBusiness with a valid token manager
            var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _tokenManager);
            var requirementResponse = rb.GetRequirementsList();

            var standardsJson = new StandardsJson
            {
                Mode = "Requirements",
                Standards = new List<StandardJson>()
            };

            // Return empty structure if no requirements found
            if (requirementResponse == null || requirementResponse.Categories == null)
            {
                return standardsJson;
            }


            // Group requirements by SetName
            var standardGroups = requirementResponse.Categories
                .GroupBy(c => c.SetName)
                .ToDictionary(g => g.Key, g => g.ToList());

            foreach (var standardGroup in standardGroups)
            {
                var standardJson = new StandardJson
                {
                    SetName = standardGroup.Key,
                    Requirements = new List<RequirementJson>()
                };

                foreach (var category in standardGroup.Value)
                {
                    if (category.SubCategories == null) continue;

                    foreach (var subCategory in category.SubCategories)
                    {
                        if (subCategory.Questions == null) continue;

                        foreach (var requirement in subCategory.Questions)
                        {
                            var requirementJson = new RequirementJson
                            {
                                RequirementId = requirement.QuestionId,
                                RequirementText = requirement.QuestionText,
                                Title = requirement.DisplayNumber
                            };

                            standardJson.Requirements.Add(requirementJson);
                        }
                    }
                }

                standardsJson.Standards.Add(standardJson);
            }

            return standardsJson;
        }


        /// <summary>
        /// Builds the sector details block for the export payload using the current assessment demographics.
        /// </summary>
        private OrganizationInfoJson BuildOrgDetails(AssessmentDetail assessment)
        {
            var details = new OrganizationInfoJson();


            // basic assessment properties
            details.CityOrSiteName = assessment.CityOrSiteName;
            details.StateProvRegion = assessment.StateProvRegion;
            details.FacilityName = assessment.FacilityName;


            // get the demographics values for the assessment
            var biz = new DemographicExtBusiness(_context);
            var demog = biz.GetExtDemographics(assessment.Id);


            if (demog.Sector != null)
            {
                var s = _context.SECTOR.FirstOrDefault(s => s.SectorId == demog.Sector.Value);
                if (s != null)
                {
                    details.SectorId = s.SectorId;
                    details.SectorName = s.SectorName;
                }
            }

            if (demog.Subsector != null)
            {
                var ss = _context.SECTOR_INDUSTRY.FirstOrDefault(x => x.IndustryId == demog.Subsector.Value);
                if (ss != null)
                {
                    details.SubsectorId = demog.Subsector.Value;
                    details.SubsectorName = ss.IndustryName;
                }
            }

            details.CisaRegion = demog.CisaRegion;


            details.CriticalServiceName = demog.CriticalServiceName;


            // IOD demographic fields

            details.AnnualBudgetFunding = demog.ListRevenueAmounts.FirstOrDefault(x => x.OptionValue == demog.AnnualRevenue)?.OptionText;
            details.NumberEmployeesInOrg = demog.ListNumberEmployeeTotal.FirstOrDefault(x => x.OptionValue == demog.NumberEmployeesTotal)?.OptionText;
            details.NumberEmployeesInDept = demog.ListNumberEmployeeUnit.FirstOrDefault(x => x.OptionValue == demog.NumberEmployeesUnit)?.OptionText;

            details.OrganizationName = demog.OrganizationName;
            details.OrganizationType = demog.ListOrgTypes.FirstOrDefault(x => x.OptionValue == demog.OrganizationType)?.OptionText;
            details.BusinessUnit = demog.BusinessUnit;
            details.UsesStandard = demog.UsesStandard;
            details.Standard1 = demog.Standard1;
            details.Standard2 = demog.Standard2;
            details.RequiredToComply = demog.RequiredToComply;
            details.RegulationType1 = demog.ListRegulationTypes.FirstOrDefault(x => x.OptionValue == demog.RegulationType1)?.OptionText;
            details.Reg1Other = demog.Reg1Other;
            details.RegulationType2 = demog.ListRegulationTypes.FirstOrDefault(x => x.OptionValue == demog.RegulationType2)?.OptionText;
            details.Reg2Other = demog.Reg2Other;

            foreach (var o in demog.ShareOrgs)
            {
                details.ShareOrgs.Add(demog.ListShareOrgs.FirstOrDefault(x => x.OptionValue == o)?.OptionText);
            }
            details.ShareOrgOther = demog.ShareOther;
            
            details.Barrier1 = demog.Barrier1;
            details.Barrier2 = demog.Barrier2;


            return details;
        }


        /// <summary>
        /// Builds the CIS demographics block for the export payload using CIS-specific demographic data.
        /// </summary>
        private CisDemographicsJson BuildCisDemographics(int assessmentId)
        {
            // Get all three types of CIS demographics
            var serviceDemographics = _cisDemographicBusiness.GetServiceDemographics(assessmentId);
            var organizationDemographics = _cisDemographicBusiness.GetOrgDemographics(assessmentId);
            var serviceComposition = _cisDemographicBusiness.GetServiceComposition(assessmentId);

            // Check if any demographics data exists
            bool hasServiceData = !string.IsNullOrEmpty(serviceDemographics.CriticalServiceDescription) ||
                                  !string.IsNullOrEmpty(serviceDemographics.ItIcsName) ||
                                  !string.IsNullOrEmpty(serviceDemographics.BudgetBasis);

            bool hasOrgData = !string.IsNullOrEmpty(organizationDemographics.OrganizationName) ||
                              !string.IsNullOrEmpty(organizationDemographics.ParentOrganization) ||
                              organizationDemographics.VisitDate.HasValue;

            bool hasCompositionData = !string.IsNullOrEmpty(serviceComposition.NetworksDescription) ||
                                      !string.IsNullOrEmpty(serviceComposition.ServicesDescription) ||
                                      serviceComposition.PrimaryDefiningSystem.HasValue;

            // If no CIS demographics data exists, return null
            if (!hasServiceData && !hasOrgData && !hasCompositionData)
            {
                return null;
            }

            // Build the CIS demographics JSON object
            var cisDemographics = new CisDemographicsJson();

            // Map service demographics if it has data
            if (hasServiceData)
            {
                cisDemographics.ServiceDemographics = new CisServiceDemographicsJson
                {
                    CriticalServiceDescription = serviceDemographics.CriticalServiceDescription,
                    ItIcsName = serviceDemographics.ItIcsName,
                    MultiSite = serviceDemographics.MultiSite,
                    MultiSiteDescription = serviceDemographics.MultiSiteDescription,
                    BudgetBasis = serviceDemographics.BudgetBasis,
                    AuthorizedOrganizationalUserCount = serviceDemographics.AuthorizedOrganizationalUserCount,
                    AuthorizedNonOrganizationalUserCount = serviceDemographics.AuthorizedNonOrganizationalUserCount,
                    CustomersCount = serviceDemographics.CustomersCount,
                    ItIcsStaffCount = serviceDemographics.ItIcsStaffCount,
                    CybersecurityItIcsStaffCount = serviceDemographics.CybersecurityItIcsStaffCount
                };
            }


            // Map organization demographics if it has data
            if (hasOrgData)
            {
                cisDemographics.OrganizationDemographics = new CisOrganizationDemographicsJson
                {
                    MotivationCrr = organizationDemographics.MotivationCrr,
                    MotivationCrrDescription = organizationDemographics.MotivationCrrDescription,
                    MotivationRrap = organizationDemographics.MotivationRrap,
                    MotivationRrapDescription = organizationDemographics.MotivationRrapDescription,
                    MotivationOrganizationRequest = organizationDemographics.MotivationOrganizationRequest,
                    MotivationOrganizationRequestDescription = organizationDemographics.MotivationOrganizationRequestDescription,
                    MotivationLawEnforcementRequest = organizationDemographics.MotivationLawEnforcementRequest,
                    MotivationLawEnforcementRequestDescription = organizationDemographics.MotivationLawEnforcementRequestDescription,
                    MotivationDirectThreats = organizationDemographics.MotivationDirectThreats,
                    MotivationDirectThreatsDescription = organizationDemographics.MotivationDirectThreatsDescription,
                    MotivationSpecialEvent = organizationDemographics.MotivationSpecialEvent,
                    MotivationSpecialEventDescription = organizationDemographics.MotivationSpecialEventDescription,
                    MotivationOther = organizationDemographics.MotivationOther,
                    MotivationOtherDescription = organizationDemographics.MotivationOtherDescription,
                    ParentOrganization = organizationDemographics.ParentOrganization,
                    OrganizationName = organizationDemographics.OrganizationName,
                    SiteName = organizationDemographics.SiteName,
                    StreetAddress = organizationDemographics.StreetAddress,
                    VisitDate = organizationDemographics.VisitDate,
                    CompletedForSltt = organizationDemographics.CompletedForSltt,
                    CompletedForFederal = organizationDemographics.CompletedForFederal,
                    CompletedForNationalSpecialEvent = organizationDemographics.CompletedForNationalSpecialEvent,
                    CikrSector = organizationDemographics.CikrSector,
                    SubSector = organizationDemographics.SubSector,
                    CustomersCount = organizationDemographics.CustomersCount,
                    ItIcsStaffCount = organizationDemographics.ItIcsStaffCount,
                    CybersecurityItIcsStaffCount = organizationDemographics.CybersecurityItIcsStaffCount
                };
            }

            // Map service composition if it has data
            if (hasCompositionData)
            {
                cisDemographics.ServiceComposition = new CisServiceCompositionJson
                {
                    NetworksDescription = serviceComposition.NetworksDescription,
                    ServicesDescription = serviceComposition.ServicesDescription,
                    ApplicationsDescription = serviceComposition.ApplicationsDescription,
                    ConnectionsDescription = serviceComposition.ConnectionsDescription,
                    PersonnelDescription = serviceComposition.PersonnelDescription,
                    OtherDefiningSystemDescription = serviceComposition.OtherDefiningSystemDescription,
                    PrimaryDefiningSystem = serviceComposition.PrimaryDefiningSystem,
                    SecondaryDefiningSystems = serviceComposition.SecondaryDefiningSystems
                };
            }

            return cisDemographics;
        }


        /// <summary>
        /// Get all observations for this assessment
        /// </summary>
        private void GetObservations(int assessmentId)
        {
            // assessment level
            var obs1 = _context.FINDING
               .Where(f => f.Assessment_Id == assessmentId)
               .Select(f => new ObservationJson
               {
                   ObservationId = f.Finding_Id,
                   Importance = f.Importance.Value ?? "",
                   Summary = f.Summary ?? "",
                   Title = f.Title ?? "",
                   Issue = f.Issue ?? "",
                   Impacts = f.Impact ?? "",
                   Recommendations = f.Recommendations ?? "",
                   Vulnerabilities = f.Vulnerabilities ?? "",
                   AutoGeneratedBy = null
               }).ToList();

            _assessmentObservations = obs1;


            // all answers
            var obs2 = _context.FINDING
                .Where(f => _context.ANSWER.Any(a => a.Assessment_Id == assessmentId && a.Answer_Id == f.Answer_Id))
                .Select(f => new ObservationJson
                {
                    ObservationId = f.Finding_Id,
                    AnswerId = (int)f.Answer_Id,
                    Importance = f.Importance.Value ?? "",
                    Summary = f.Summary ?? "",
                    Title = f.Title ?? "",
                    Issue = f.Issue ?? "",
                    Impacts = f.Impact ?? "",
                    Recommendations = f.Recommendations ?? "",
                    Vulnerabilities = f.Vulnerabilities ?? "",
                    AutoGeneratedBy = f.Auto_Generated == 2 ? "VADR" : null
                }).ToList();
            _answerObservations = obs2;
        }
    }
}
