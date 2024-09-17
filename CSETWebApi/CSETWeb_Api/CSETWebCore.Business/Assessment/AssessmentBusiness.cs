//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Observations;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;


namespace CSETWebCore.Business.Assessment
{
    public class AssessmentBusiness : IAssessmentBusiness, ICreateAssessmentBusiness
    {
        private readonly ITokenManager _tokenManager;
        private readonly IUtilities _utilities;
        private readonly IContactBusiness _contactBusiness;
        private readonly ISalBusiness _salBusiness;
        private readonly IMaturityBusiness _maturityBusiness;
        private readonly IACETMaturityBusiness _acetMaturityBusiness;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IStandardsBusiness _standardsBusiness;
        private readonly IDiagramManager _diagramManager;

        private readonly TranslationOverlay _overlay;


        private CSETContext _context;

        public AssessmentBusiness(IHttpContextAccessor httpContext, ITokenManager authentication,
            IUtilities utilities, IContactBusiness contactBusiness, ISalBusiness salBusiness,
            IMaturityBusiness maturityBusiness, IAssessmentUtil assessmentUtil, IStandardsBusiness standardsBusiness,
            IDiagramManager diagramManager, CSETContext context)
        {
            _tokenManager = authentication;
            _utilities = utilities;
            _contactBusiness = contactBusiness;
            _salBusiness = salBusiness;
            _maturityBusiness = maturityBusiness;
            _assessmentUtil = assessmentUtil;
            _standardsBusiness = standardsBusiness;
            _context = context;
            _diagramManager = new Diagram.DiagramManager(context);
            _overlay = new TranslationOverlay();
        }


        public AssessmentDetail CreateNewAssessment(int? currentUserId, string workflow, GalleryConfig config)
        {
            DateTime nowUTC = DateTime.UtcNow;

            string defaultExecSumm = "Cyber terrorism is a real and growing threat. Standards and guides have been developed, vetted, and widely accepted" +
                                     " to assist with protection from cyber attacks. The Cyber Security Evaluation Tool (CSET) includes a selectable array of these standards for" +
                                     " a tailored assessment of cyber vulnerabilities. Once the standards were selected and the resulting question sets answered, the CSET created" +
                                     " a compliance summary, compiled variance statistics, ranked top areas of concern, and generated security recommendations.";

            string defaultAssessmentName = "New Assessment";

            var lang = _tokenManager.GetCurrentLanguage();
            if (lang != "en")
            {
                var msg = _overlay.GetPropertyValue("GENERIC", "default exec summ", lang);
                if (msg != null)
                {
                    defaultExecSumm = msg;
                }

                msg = _overlay.GetPropertyValue("GENERIC", "default assessment name", lang);
                if (msg != null)
                {
                    defaultAssessmentName = msg;
                }
            }


            AssessmentDetail newAssessment = new AssessmentDetail
            {
                AssessmentName = defaultAssessmentName,
                AssessmentDate = nowUTC,
                CreatorId = currentUserId,
                CreatedDate = nowUTC,
                LastModifiedDate = nowUTC,
                AssessmentEffectiveDate = nowUTC,
                Workflow = workflow,
                ExecutiveSummary = defaultExecSumm,
                GalleryItemGuid = config.GalleryGuid,
                ISE_StateLed = false,
                IseSubmitted = false,
            };


            // Commit the new assessment
            int assessment_id = SaveAssessmentDetail(0, newAssessment);
            newAssessment.Id = assessment_id;


            // Add the current user to the new assessment as an admin that has already been 'invited'
            if (currentUserId != null)
            {
                _contactBusiness.AddContactToAssessment(assessment_id, (int)currentUserId, Constants.Constants.AssessmentAdminId, true);
            }

            // Add a connection to the AccessKey if that's how the user is using CSET
            if (_tokenManager.GetAccessKey() != null)
            {
                var aka = new ACCESS_KEY_ASSESSMENT()
                {
                    AccessKey = _tokenManager.GetAccessKey(),
                    Assessment_Id = assessment_id
                };

                _context.Add(aka);
                _context.SaveChanges();
            }


            string defaultSal = "Low";
            _salBusiness.SetDefaultSALs(assessment_id, defaultSal);


            _standardsBusiness.PersistSelectedStandards(assessment_id, null);

            return newAssessment;
        }


        /// <summary>
        /// Creates a new assessment for import. The assessmentGuid parameter is optional. If specified, the newly created assessment
        /// will use the provided guid value. Otherwise, it will be asssigned randomly.
        /// </summary>
        /// <param name="currentUserId"></param>
        /// <param name="accessKey"></param>
        /// <param name="assessmentGuid"></param>
        /// <returns></returns>
        public AssessmentDetail CreateNewAssessmentForImport(int? currentUserId, string accessKey, Guid assessmentGuid = new Guid())
        {
            DateTime nowUTC = DateTime.Now;
            AssessmentDetail newAssessment = new AssessmentDetail
            {
                AssessmentGuid = assessmentGuid,
                AssessmentName = "New Assessment",
                AssessmentDate = nowUTC,
                CreatorId = currentUserId,
                CreatedDate = nowUTC,
                LastModifiedDate = nowUTC,
                AssessmentEffectiveDate = nowUTC
            };

            // Commit the new assessment
            int assessment_id = SaveAssessmentDetail(0, newAssessment);
            newAssessment.Id = assessment_id;



            // Add the current user to the new assessment as an admin that has already been 'invited'
            if (currentUserId != null)
            {
                _contactBusiness.AddContactToAssessment(assessment_id, (int)currentUserId, Constants.Constants.AssessmentAdminId, true);
            }

            if (accessKey != null)
            {
                var aka = new ACCESS_KEY_ASSESSMENT()
                {
                    AccessKey = accessKey,
                    Assessment_Id = assessment_id
                };

                _context.Add(aka);
                _context.SaveChanges();
            }

            return newAssessment;
        }


        /// <summary>
        /// Returns a collection of Assessment objects that are connected to the specified user.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public IEnumerable<usp_Assessments_For_UserResult> GetAssessmentsForUser(int userId)
        {
            List<usp_Assessments_For_UserResult> list = new List<usp_Assessments_For_UserResult>();
            list = _context.usp_AssessmentsForUser(userId).ToList();

            // convert dates from UTC to local 
            list.ForEach(x =>
            {
                x.LastModifiedDate = _utilities.UtcToLocal(x.LastModifiedDate ?? DateTime.UtcNow);
                x.AssessmentCreatedDate = x.AssessmentCreatedDate;
                x.AssessmentDate = x.AssessmentDate;

                var query = from u in _context.USERS
                            where u.UserId == x.UserId
                            select u;
                var result = query.ToList().FirstOrDefault();

                x.firstName = result.FirstName;
                x.lastName = result.LastName;
            });

            return list;
        }


        /// <summary>
        /// Returns a collection of Assessment objects that are connected to the specified access key.
        /// </summary>
        /// <param name="accessKey"></param>
        /// <returns></returns>
        public IEnumerable<usp_Assessments_For_UserResult> GetAssessmentsForAccessKey(string accessKey)
        {
            var dbAssessmentList = _context.ACCESS_KEY_ASSESSMENT.Where(x => x.AccessKey == accessKey)
                .Include(x => x.Assessment)
                .ThenInclude(x => x.INFORMATION)
                .ToList();

            var allStandards = _context.SETS.ToList();

            TinyMapper.Bind<ASSESSMENTS, usp_Assessments_For_UserResult>();
            var list = new List<usp_Assessments_For_UserResult>();
            foreach (var l in dbAssessmentList)
            {
                AssessmentDetail assessment = GetAssessmentDetail(l.Assessment_Id);
                var aaa = TinyMapper.Map<ASSESSMENTS, usp_Assessments_For_UserResult>(l.Assessment);
                aaa.AssessmentId = l.Assessment_Id;
                aaa.AssessmentName = l.Assessment.INFORMATION.Assessment_Name;
                aaa.SelectedMaturityModel = assessment.MaturityModel?.ModelName ?? "";
                if (assessment.UseStandard)
                {
                    for (int i = 0; i < assessment.Standards.Count; i++)
                    {
                        aaa.SelectedStandards += allStandards.Find(s => s.Set_Name == assessment.Standards[i])?.Short_Name + ", ";

                        if (i == assessment.Standards.Count - 1)
                        {
                            aaa.SelectedStandards = aaa.SelectedStandards[..^2];
                        }
                    }
                }
                else
                {
                    aaa.SelectedStandards = "";
                }

                list.Add(aaa);
            }

            return list;
        }


        /// <summary>
        /// Returns a collection of Assessment objects that are connected to the specified user.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public IEnumerable<usp_Assessments_Completion_For_UserResult> GetAssessmentsCompletionForUser(int userId)
        {
            List<usp_Assessments_Completion_For_UserResult> list = new List<usp_Assessments_Completion_For_UserResult>();
            list = _context.usp_AssessmentsCompletionForUser(userId).ToList();

            return list;
        }


        /// <summary>
        /// Returns a collection of Assessment objects that are connected to the specified access key.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public IEnumerable<usp_Assessments_Completion_For_UserResult> GetAssessmentsCompletionForAccessKey(string accessKey)
        {
            List<usp_Assessments_Completion_For_UserResult> list = new List<usp_Assessments_Completion_For_UserResult>();
            list = _context.usp_AssessmentsCompletionForAccessKey(accessKey).ToList();

            return list;
        }

        public AggregationAssessment GetAggregationAssessmentDetail(int assessmentId)
        {
            AggregationAssessment aggregation = new AggregationAssessment();

            var query = from aa in _context.ASSESSMENTS
                        where aa.Assessment_Id == assessmentId
                        select aa;

            var result = query.ToList().FirstOrDefault();
            if (result != null)
            {
                aggregation.Assessment = new ASSESSMENTS();
                aggregation.Assessment = result;
                aggregation.Answers = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId).ToList();
                aggregation.Demographics = _context.DEMOGRAPHICS.FirstOrDefault(x => x.Assessment_Id == assessmentId);
                aggregation.Documents = _context.DOCUMENT_FILE.Where(x => x.Assessment_Id == assessmentId).ToList();
                aggregation.Findings = (from a in aggregation.Answers
                                        join f in _context.FINDING on a.Answer_Id equals f.Answer_Id
                                        select f).ToList();

            }
            return aggregation;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public AnalyticsAssessment GetAnalyticsAssessmentDetail(int assessmentId)
        {
            AnalyticsAssessment assessment = new AnalyticsAssessment();

            string app_code = _tokenManager.Payload(Constants.Constants.Token_Scope);


            var query = from aa in _context.ASSESSMENTS
                        where aa.Assessment_Id == assessmentId
                        select aa;

            int tmpUID = 0;
            Guid tmpGuid = Guid.NewGuid();

            if (int.TryParse(_tokenManager.Payload(Constants.Constants.Token_UserId), out tmpUID))
            {
                USERS user = _context.USERS.Where(x => x.UserId == tmpUID).FirstOrDefault();
                if (user != null)
                {
                    if (user.Id != null)
                    {
                        user.Id = tmpGuid;
                        _context.SaveChanges();
                    }
                    else
                    {
                        tmpGuid = user.Id ?? Guid.NewGuid();
                    }
                }
            }


            var result = query.ToList().FirstOrDefault();
            var modeResult = query.Join(_context.STANDARD_SELECTION, x => x.Assessment_Id, y => y.Assessment_Id, (x, y) => y)
                .FirstOrDefault();

            if (result != null)
            {

                assessment = new AnalyticsAssessment()
                {
                    Alias = result.Alias,
                    AssessmentCreatedDate = result.AssessmentCreatedDate,
                    AssessmentCreatorId = tmpGuid.ToString(),
                    Assessment_Date = result.Assessment_Date,
                    Assessment_GUID = result.Assessment_GUID.ToString(),
                    LastModifiedDate = _utilities.UtcToLocal((DateTime)result.LastModifiedDate),
                    Mode = modeResult?.Application_Mode
                };
            }

            return assessment;

        }

        /// <summary>
        /// Returns the details for the specified Assessments given a GUID.
        /// Returns null if no assessment with the provided GUID exists.
        /// </summary>
        /// <param name="assessmentGuid"></param>
        /// <returns></returns>
        public AssessmentDetail GetAssessmentDetail(Guid assessmentGuid)
        {
            var assessment = _context.ASSESSMENTS.FirstOrDefault(assessment => assessment.Assessment_GUID == assessmentGuid);

            if (assessment == null)
            {
                return null;
            }

            return GetAssessmentDetail(assessment.Assessment_Id);
        }

        /// <summary>
        /// Returns the details for the specified Assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public AssessmentDetail GetAssessmentDetail(int assessmentId, string token = "")
        {
            AssessmentDetail assessment = new AssessmentDetail();
            if (!string.IsNullOrEmpty(token))
                _tokenManager.Init(token);
            string app_code = _tokenManager.Payload(Constants.Constants.Token_Scope);

            var query = (from ii in _context.INFORMATION
                         join aa in _context.ASSESSMENTS on ii.Id equals aa.Assessment_Id
                         where ii.Id == assessmentId
                         select new { ii, aa });

            var result = query.ToList().FirstOrDefault();
            if (result != null)
            {
                assessment.Id = result.aa.Assessment_Id;
                assessment.AssessmentGuid = result.aa.Assessment_GUID;
                assessment.GalleryItemGuid = result.aa.GalleryItemGuid;
                assessment.AssessmentName = result.ii.Assessment_Name;
                assessment.AssessmentDate = result.aa.Assessment_Date;
                assessment.FacilityName = result.ii.Facility_Name;
                assessment.CityOrSiteName = result.ii.City_Or_Site_Name;
                assessment.StateProvRegion = result.ii.State_Province_Or_Region;
                assessment.PostalCode = result.ii.Postal_Code;
                assessment.ExecutiveSummary = result.ii.Executive_Summary;
                assessment.AssessmentDescription = result.ii.Assessment_Description;
                assessment.AdditionalNotesAndComments = result.ii.Additional_Notes_And_Comments;
                assessment.CreatorId = result.aa.AssessmentCreatorId ?? 0;
                assessment.CreatedDate = result.aa.AssessmentCreatedDate;
                assessment.LastModifiedDate = _utilities.UtcToLocal((DateTime)result.aa.LastModifiedDate);
                assessment.AssessmentEffectiveDate = result.aa.AssessmentEffectiveDate ?? DateTime.UtcNow;
                assessment.DiagramMarkup = result.aa.Diagram_Markup;
                assessment.DiagramImage = result.aa.Diagram_Image;
                assessment.ISE_StateLed = result.aa.ISE_StateLed;
                assessment.RegionCode = result.ii.Region_Code;
                assessment.is_PCII = result.aa.Is_PCII;
                assessment.PciiNumber = result.aa.PCII_Number;
                assessment.IseSubmitted = result.ii.Ise_Submitted;

                assessment.CreatorName = new User.UserBusiness(_context, null)
                    .GetUserDetail((int)assessment.CreatorId)?.FullName;

                assessment.UseStandard = result.aa.UseStandard;
                if (assessment.UseStandard)
                {
                    GetSelectedStandards(ref assessment);
                }

                assessment.UseDiagram = result.aa.UseDiagram;

                assessment.UseMaturity = result.aa.UseMaturity;
                if (assessment.UseMaturity)
                {
                    GetMaturityModelDetails(ref assessment);
                }

                assessment.Workflow = result.ii.Workflow;

                // set workflow for legacy assessments
                if (string.IsNullOrEmpty(assessment.Workflow))
                {
                    if (result.ii.IsAcetOnly ?? false)
                    {
                        assessment.Workflow = "ACET";
                    }
                    else
                    {
                        assessment.Workflow = "BASE";
                    }
                }

                assessment.Origin = result.ii.Origin;

                // for older assessments, if no features are set, look for actual data and set them
                if (!assessment.UseMaturity && !assessment.UseStandard && !assessment.UseDiagram)
                {
                    SetFeaturesOnAssessmentRecord(assessment.Id);


                    // populate assessment with feature values from DB
                    var dbAssessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId);

                    assessment.UseStandard = dbAssessment.UseStandard;
                    assessment.UseDiagram = dbAssessment.UseDiagram;
                    assessment.UseMaturity = dbAssessment.UseMaturity;
                    assessment.MaturityModel = _maturityBusiness.GetMaturityModel(assessmentId);
                }

                SetAssessmentTypeInfo(assessment);


                var ss = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
                if (ss != null)
                {
                    if (ss.Hidden_Screens != null)
                    {
                        assessment.HiddenScreens.AddRange(ss.Hidden_Screens.ToLower().Split(","));
                    }

                    assessment.ApplicationMode = ss.Application_Mode.Substring(0, 1).ToUpper();
                }


                // Some demographics
                var d1 = new Demographic.DemographicBusiness(_context, _assessmentUtil);
                var d1Sector = d1.GetDemographics(assessmentId).SectorId;
                assessment.SectorId = d1Sector;

                var d2 = new Demographic.DemographicExtBusiness(_context);
                var d2Sector  = (int?)d2.GetX(assessmentId, "SECTOR");
                if (d2Sector != null)
                {
                    assessment.SectorId = d2Sector;
                }


                bool defaultAcet = (app_code == "ACET");
                assessment.IsAcetOnly = result.ii.IsAcetOnly != null ? result.ii.IsAcetOnly : defaultAcet;

                assessment.BaselineAssessmentId = result.ii.Baseline_Assessment_Id;
                if (assessment.BaselineAssessmentId != null)
                {
                    var baseInfo = _context.INFORMATION.FirstOrDefault(x => x.Id == assessment.BaselineAssessmentId);
                    assessment.BaselineAssessmentName = baseInfo.Assessment_Name;
                }


                // ACET-specific fields
                assessment.Charter = string.IsNullOrEmpty(result.aa.Charter) ? "" : result.aa.Charter;
                assessment.CreditUnion = result.aa.CreditUnionName;
                assessment.Assets = result.aa.Assets != null ? long.Parse(result.aa.Assets) : 0;


                // Fields located on the Overview page
                assessment.ExecutiveSummary = result.ii.Executive_Summary;
                assessment.AssessmentDescription = result.ii.Assessment_Description;
                assessment.AdditionalNotesAndComments = result.ii.Additional_Notes_And_Comments;
            }

            return assessment;
        }


        /// <summary>
        /// Returns the last modified date of the assessment.
        /// This is to provide a lightweight query when all the other
        /// assessment detail is not needed.
        /// 
        /// Returns the current UTC time if not available.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public DateTime GetLastModifiedDateUtc(int assessmentId)
        {
            string app_code = _tokenManager.Payload(Constants.Constants.Token_Scope);

            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (assessment != null)
            {
                return assessment.LastModifiedDate ?? DateTime.UtcNow;
            }

            return DateTime.UtcNow;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public void GetMaturityModelDetails(ref AssessmentDetail assessment)
        {
            int assessmentId = assessment.Id;

            assessment.MaturityModel = _maturityBusiness.GetMaturityModel(assessmentId);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessment"></param>
        /// <param name="db"></param>
        public void GetSelectedStandards(ref AssessmentDetail assessment)
        {
            var assessmentId = assessment.Id;
            var standardsList = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected).ToList();
            assessment.Standards = new List<string>();
            foreach (var s in standardsList)
            {
                assessment.Standards.Add(s.Set_Name);
            }
        }


        /// <summary>
        /// Set features based on existence of data.  This is used for assessments that were
        /// created prior to incorporating features into the assessment data model.
        /// </summary>
        /// <param name="assessment"></param>
        public void SetFeaturesOnAssessmentRecord(int assessmentId)
        {
            var dbAssessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId);

            dbAssessment.UseStandard = _context.AVAILABLE_STANDARDS.Any(x => x.Assessment_Id == assessmentId);

            dbAssessment.UseDiagram = _context.ASSESSMENT_DIAGRAM_COMPONENTS.Any(x => x.Assessment_Id == assessmentId)
               && _diagramManager.HasDiagram(assessmentId);

            dbAssessment.UseMaturity = _context.AVAILABLE_MATURITY_MODELS.Any(x => x.Assessment_Id == assessmentId);

            if (!dbAssessment.UseMaturity)
            {
                // determine if there are maturity answers and attach maturity models
                var maturityAnswers = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Type.ToLower() == "maturity").ToList();
                if (maturityAnswers.Count > 0)
                {
                    dbAssessment.UseMaturity = true;

                    // if we have maturity answers but no selected model, assume the selected model
                    if (!_context.AVAILABLE_MATURITY_MODELS.Any(x => x.Assessment_Id == assessmentId))
                    {
                        // determine the maturity models represented by the questions that have been answered
                        var qqq = _context.MATURITY_QUESTIONS.Where(q => maturityAnswers.Select(x => x.Question_Or_Requirement_Id).Contains(q.Mat_Question_Id)).ToList();
                        var maturityModelIds = qqq.Select(x => x.Maturity_Model_Id).Distinct().ToList();
                        foreach (var modelId in maturityModelIds)
                        {
                            var mm = new AVAILABLE_MATURITY_MODELS()
                            {
                                Assessment_Id = assessmentId,
                                model_id = modelId,
                                Selected = true
                            };

                            _context.AVAILABLE_MATURITY_MODELS.Add(mm);
                        }
                    }
                }
            }

            _context.SaveChanges();
        }


        /// <summary>
        /// Persists data to the ASSESSMENTS and INFORMATION tables.
        /// Date fields should be converted to UTC before sending the Assessment
        /// to this method.
        /// </summary>
        /// <param name="assessment"></param>
        /// <returns></returns>
        public int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment)
        {
            string app_code = _tokenManager.Payload(Constants.Constants.Token_Scope);

            // Add or update the ASSESSMENTS record
            var dbAssessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            if (dbAssessment == null)
            {
                dbAssessment = new ASSESSMENTS();

                if (assessment.AssessmentGuid != Guid.Empty)
                {
                    dbAssessment.Assessment_GUID = assessment.AssessmentGuid;
                }
                else 
                {
                    dbAssessment.Assessment_GUID = Guid.NewGuid();
                }

                _context.ASSESSMENTS.Add(dbAssessment);
                _context.SaveChanges();
                assessmentId = dbAssessment.Assessment_Id;
            }

            dbAssessment.Assessment_Id = assessmentId;
            dbAssessment.GalleryItemGuid = assessment.GalleryItemGuid;
            dbAssessment.AssessmentCreatedDate = assessment.CreatedDate;
            dbAssessment.AssessmentCreatorId = assessment.CreatorId == 0 ? null : assessment.CreatorId;
            dbAssessment.Assessment_Date = assessment.AssessmentDate ?? DateTime.Now;
            dbAssessment.AssessmentEffectiveDate = assessment.AssessmentEffectiveDate ?? DateTime.Now;
            dbAssessment.LastModifiedDate = assessment.LastModifiedDate;

            dbAssessment.UseDiagram = assessment.UseDiagram;
            dbAssessment.UseMaturity = assessment.UseMaturity;
            dbAssessment.UseStandard = assessment.UseStandard;

            dbAssessment.Charter = "00000";
            dbAssessment.Assets = assessment.Assets.ToString();
            dbAssessment.Diagram_Markup = assessment.DiagramMarkup;
            dbAssessment.Diagram_Image = assessment.DiagramImage;
            dbAssessment.AnalyzeDiagram = false;
            dbAssessment.PCII_Number = assessment.PciiNumber;
            dbAssessment.Is_PCII = assessment.is_PCII;

            _context.ASSESSMENTS.Update(dbAssessment);
            _context.SaveChanges();


            var user = _context.USERS.FirstOrDefault(x => x.UserId == dbAssessment.AssessmentCreatorId);

            var dbInformation = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            if (dbInformation == null)
            {
                dbInformation = new INFORMATION()
                {
                    Id = assessmentId,
                    Assessment_Name = ""
                };
                _context.INFORMATION.Add(dbInformation);
                _context.SaveChanges();
            }

            // add or update the INFORMATION record
            dbInformation.Assessment_Name = assessment.AssessmentName;
            dbInformation.Facility_Name = assessment.FacilityName;
            dbInformation.City_Or_Site_Name = assessment.CityOrSiteName;
            dbInformation.State_Province_Or_Region = assessment.StateProvRegion;
            dbInformation.Postal_Code = assessment.PostalCode;
            dbInformation.Executive_Summary = assessment.ExecutiveSummary;
            dbInformation.Assessment_Description = assessment.AssessmentDescription;
            dbInformation.Additional_Notes_And_Comments = assessment.AdditionalNotesAndComments;
            dbInformation.IsAcetOnly = assessment.IsAcetOnly;
            dbInformation.Workflow = assessment.Workflow;
            dbInformation.Origin = assessment.Origin;
            dbInformation.Region_Code = assessment.RegionCode;
            dbInformation.Ise_Submitted = assessment.IseSubmitted;

            _context.INFORMATION.Update(dbInformation);
            _context.SaveChanges();


            // persist maturity data
            if (assessment.UseMaturity)
            {
                _maturityBusiness.PersistSelectedMaturityModel(assessmentId, assessment.MaturityModel?.ModelName);
            }
            else
            {
                _maturityBusiness.ClearMaturityModel(assessmentId);
            }

            // No user is null here if accesskey login is used
            if (user != null)
            {
                AssessmentNaming.ProcessName(_context, user.UserId, assessmentId);
            }
            _assessmentUtil.TouchAssessment(assessmentId);

            return assessmentId;
        }




        /// <summary>
        /// Get all organization types
        /// </summary>
        /// <param></param>
        /// <returns></returns>
        public List<DEMOGRAPHICS_ORGANIZATION_TYPE> GetOrganizationTypes()
        {
            var list = new List<DEMOGRAPHICS_ORGANIZATION_TYPE>();
            list = _context.DEMOGRAPHICS_ORGANIZATION_TYPE.ToList();

            var lang = _tokenManager.GetCurrentLanguage();
            if (lang != "en")
            {
                list.ForEach(x =>
                {
                    var val = _overlay.GetValue("DEMOGRAPHICS_ORGANIZATION_TYPE", x.OrganizationTypeId.ToString(), lang)?.Value;
                    if (val != null)
                    {
                        x.OrganizationType = val;
                    }
                });
            }

            return list;
        }

        /// <summary>
        /// Returns a boolean indicating if the current User is attached to the specified Assessment.
        /// The authentication token is automatically read and the user is determined from it.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public bool IsCurrentUserOnAssessment(int assessmentId)
        {
            var currentUserId = _tokenManager.GetUserId();

            int countAC = _context.ASSESSMENT_CONTACTS.Where(ac => ac.Assessment_Id == assessmentId
            && ac.UserId == currentUserId).Count();

            return (countAC > 0);
        }

        /// <summary>
        /// Get assessment from given assessment Id
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public ASSESSMENTS GetAssessmentById(int assessmentId)
        {
            return _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
        }

        /// <summary>
        /// Sets the assessment type title and description.
        /// </summary>
        /// <param name="assessment"></param>
        public void SetAssessmentTypeInfo(AssessmentDetail assessment)
        {
            // Check for old assessment with multiple assessment types.
            bool multipleTypes = (assessment.UseStandard && assessment.Standards?.Count > 1)
                                || (assessment.UseDiagram && assessment.UseMaturity)
                                || (assessment.UseDiagram && assessment.UseStandard)
                                || (assessment.UseMaturity && assessment.UseStandard);

            // Grab the Gallery Card Item Description to use elsewhere in the assessment.
            // This replaces the old Maturity_Model_Description & Set tooltips
            string galleryCardDescription = "";
            var query = from g in _context.GALLERY_ITEM
                        where g.Gallery_Item_Guid == assessment.GalleryItemGuid
                        select g;

            var result = query.ToList().FirstOrDefault();

            var lang = _tokenManager.GetCurrentLanguage();

            if (result != null)
            {
                // Translate if not English
                if (lang != "en")
                {
                    var itemOverlay = _overlay.GetJObject("GALLERY_ITEM", "key", result.Gallery_Item_Guid.ToString(), lang);

                    if (itemOverlay != null)
                    {
                        result.Title = itemOverlay.Value<string>("title");
                        result.Description = itemOverlay.Value<string>("description");
                    }
                }

                galleryCardDescription = result.Description;
            }

            if (assessment.UseMaturity)
            {
                if (assessment.MaturityModel == null)
                {
                    // Try to get the maturity model if it's null for some reason
                    assessment.MaturityModel = _maturityBusiness.GetMaturityModel(assessment.Id);
                }

                // Use shorter names on assessments with multiple types.
                assessment.TypeTitle += ", " + assessment.MaturityModel?.ModelTitle;

                var modelObject = _overlay.GetJObject("MATURITY_MODELS", "maturity_model_id", (assessment.MaturityModel.ModelId).ToString(), lang);
                if (modelObject != null)
                {
                    assessment.TypeTitle = modelObject.Value<string>("model_title");
                }

                assessment.TypeDescription = galleryCardDescription;
            }

            if (assessment.UseStandard)
            {
                GatherSetsInfo(assessment.Standards).ForEach(standard =>
                {
                    // Use shorter names on assessments with multiple types.
                    assessment.TypeTitle += ", " + (multipleTypes ? standard.ShortName : standard.FullName);
                    assessment.TypeDescription = galleryCardDescription;
                });
            }

            if (assessment.UseDiagram)
            {
                assessment.TypeTitle += ", Network Diagram";
                assessment.TypeDescription = "A Network Architecture and Diagram Based assessment. This assessment requires that you build " +
                    "or import an assessment into CSET and creates a question set specifically tailored to your network configuration.";
            }

            if (assessment.TypeTitle != null)
            {
                if (assessment.TypeTitle.StartsWith(","))
                {
                    assessment.TypeTitle = assessment.TypeTitle.TrimStart(", ".ToCharArray());
                }
            }

            // Remove description for assessments with multiple types.
            if (multipleTypes)
            {
                assessment.TypeDescription = null;
            }
        }


        public List<SetInfo> GatherSetsInfo(List<string> setNames)
        {
            var allSets = _context.SETS.ToList();
            List<SetInfo> processedSets = new List<SetInfo>();
            foreach (string setName in setNames)
            {
                var set = allSets.Find(set => string.Equals(set.Set_Name, setName, StringComparison.CurrentCultureIgnoreCase));
                processedSets.Add(new SetInfo { FullName = set.Full_Name, ShortName = set.Short_Name });
            }
            return processedSets;
        }

        public class SetInfo
        {
            public string FullName { get; set; }
            public string ShortName { get; set; }
        }

        public IList<string> GetNames(int id1, int id2, int? id3, int? id4, int? id5, int? id6, int? id7, int? id8, int? id9, int? id10)
        {
            int?[] myArray = new int?[]
            {
                id1,id2,id3,id4,id5,id6,id7,id8,id9,id10
            };

            List<int?> myList = new List<int?>();
            foreach (int? item in myArray)
            {
                if (item != null && item != 0)
                {
                    myList.Add(item);
                }
            }

            var results = _context.INFORMATION.Where(x => myList.Contains(x.Id)).Select(x => x.Assessment_Name).ToList();


            return results;
        }


        /// <summary>
        /// Gets the OTHER-REMARKS detail record 
        /// </summary>
        /// <returns></returns>
        public string GetOtherRemarks(int assessmentId)
        {
            var dd = _context.DETAILS_DEMOGRAPHICS
                .Where(x => x.Assessment_Id == assessmentId && x.DataItemName == "OTHER-REMARKS").FirstOrDefault();

            if (dd != null)
            {
                return dd.StringValue;
            }

            return "";
        }


        /// <summary>
        /// Persists OTHER-REMARKS.
        /// </summary>
        /// <param name="remark"></param>
        public void SaveOtherRemarks(int assessmentId, string remark)
        {
            var dd = _context.DETAILS_DEMOGRAPHICS
               .Where(x => x.Assessment_Id == assessmentId && x.DataItemName == "OTHER-REMARKS").FirstOrDefault();

            if (dd == null)
            {
                dd = new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = "OTHER-REMARKS"
                };
                _context.DETAILS_DEMOGRAPHICS.Add(dd);
            }

            dd.StringValue = remark;
            _context.SaveChanges();
        }

        public void clearFirstTime(int userid, int assessment_id)
        {
            var us = _context.USERS.Where(x => x.UserId == userid).FirstOrDefault();
            if (us != null)
            {
                us.IsFirstLogin = false;
                _context.SaveChanges();
            }
        }

        public void MoveHydroActionsOutOfIseActions()
        {
            _utilities.MoveActionItemsFrom_IseActions_To_HydroData(_context);
        }

        public IEnumerable<MergeObservation> GetAssessmentObservations(int id1, int id2, int? id3, int? id4, int? id5, int? id6, int? id7, int? id8, int? id9, int? id10)
        {
            int?[] myArray = new int?[]
            {
                id1,id2,id3,id4,id5,id6,id7,id8,id9,id10
            };

            List<int?> myList = new List<int?>();
            foreach (int? item in myArray)
            {
                if (item != null && item != 0)
                {
                    myList.Add(item);
                }
            }

            List<MergeObservation> observationsPerAssessment = new List<MergeObservation>();

            foreach (int assessId in myList)
            {
                var results = (from a in _context.ANSWER
                               join f in _context.FINDING on a.Answer_Id equals f.Answer_Id
                               where a.Assessment_Id == assessId
                               select new { a, f }).ToList();

                var answerFindingPair = results.Select(x => new { x.a, x.f }).Distinct();

                List<FINDING> observationList = new List<FINDING>();

                foreach (var pair in answerFindingPair)
                {
                    observationList.Add(pair.f);
                }

                foreach (var obs in observationList)
                {
                    var findingContact = _context.FINDING_CONTACT.Where(x => x.Finding_Id == obs.Finding_Id).ToList();
                    if (findingContact != null)
                    {
                        obs.FINDING_CONTACT = findingContact;
                    }
                }

                observationsPerAssessment.Add(new MergeObservation(assessId, observationList));
            }

            return observationsPerAssessment;
        }

        public IEnumerable<MergeDocuments> GetAssessmentDocuments(int id1, int id2, int? id3, int? id4, int? id5, int? id6, int? id7, int? id8, int? id9, int? id10)
        {
            int?[] myArray = new int?[]
            {
                id1,id2,id3,id4,id5,id6,id7,id8,id9,id10
            };

            List<int?> myList = new List<int?>();
            foreach (int? item in myArray)
            {
                if (item != null && item != 0)
                {
                    myList.Add(item);
                }
            }

            List<MergeDocuments> documentsPerAssessment = new List<MergeDocuments>();
            foreach (int assessId in myList)
            {
                var results = (from a in _context.ANSWER
                               join da in _context.DOCUMENT_ANSWERS on a.Answer_Id equals da.Answer_Id
                               join f in _context.DOCUMENT_FILE on da.Document_Id  equals f.Document_Id
                               where a.Assessment_Id == assessId
                               select new { a, da, f }).ToList();

                var answerFindingPair = results.Select(x => new { x.a, x.da, x.f }).Distinct();

                List<DocumentWithAnswerId> documentList = new List<DocumentWithAnswerId>();
                foreach (var pair in answerFindingPair)
                {
                    DocumentWithAnswerId document = new DocumentWithAnswerId();
                    document.Document_Id = pair.f.Document_Id;
                    document.FileName = pair.f.Name;
                    document.Title = pair.f.Title;
                    document.Answer_Id = pair.da.Answer_Id;
                    document.Question_Id = pair.a.Question_Or_Requirement_Id;
                    
                    documentList.Add(document);
                }

                documentsPerAssessment.Add(new MergeDocuments(assessId, documentList));
            }

            return documentsPerAssessment;
        }
    }
}