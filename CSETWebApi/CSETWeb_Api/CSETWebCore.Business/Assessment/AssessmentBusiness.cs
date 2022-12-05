using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Acet;
using CSETWebCore.Model.Assessment;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;

namespace CSETWebCore.Business.Assessment
{
    public class AssessmentBusiness : IAssessmentBusiness
    {
        private readonly ITokenManager _tokenManager;
        private readonly IUtilities _utilities;
        private readonly IContactBusiness _contactBusiness;
        private readonly ISalBusiness _salBusiness;
        private readonly IMaturityBusiness _maturityBusiness;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IStandardsBusiness _standardsBusiness;
        private readonly IDiagramManager _diagramManager;

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
            _diagramManager = diagramManager;
            _context = context;
        }


        public AssessmentDetail CreateNewAssessment(int? currentUserId, string workflow)
        {
            DateTime nowUTC = _utilities.UtcToLocal(DateTime.UtcNow);

            string defaultExecSumm = "Cyber terrorism is a real and growing threat. Standards and guides have been developed, vetted, and widely accepted" +
                                     " to assist with protection from cyber attacks. The Cyber Security Evaluation Tool (CSET) includes a selectable array of these standards for" +
                                     " a tailored assessment of cyber vulnerabilities. Once the standards were selected and the resulting question sets answered, the CSET created" +
                                     " a compliance summary, compiled variance statistics, ranked top areas of concern, and generated security recommendations.";

            AssessmentDetail newAssessment = new AssessmentDetail
            {
                AssessmentName = (workflow.ToLower() == "acet") ?
                    "ACET 00000 " + DateTime.Now.ToString("MMddyy") : "New Assessment",
                AssessmentDate = nowUTC,
                CreatorId = currentUserId,
                CreatedDate = nowUTC,
                LastModifiedDate = nowUTC,
                Workflow = workflow,
                ExecutiveSummary = defaultExecSumm

            };

            if (newAssessment.Workflow == "TSA")
            {
                SetDefaultTsaStuff(newAssessment);
            }

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
            if (newAssessment.Workflow == "TSA")
            {
                defaultSal = SalBusiness.DefaultSalTsa;
            }
            _salBusiness.SetDefaultSALs(assessment_id, defaultSal);


            _standardsBusiness.PersistSelectedStandards(assessment_id, null);

            if (newAssessment.Workflow == "TSA")
            {
                _standardsBusiness.PersistDefaultSelectedStandard(assessment_id);
            }


            CreateIrpHeaders(assessment_id);

            return newAssessment;
        }



        public AssessmentDetail CreateNewAssessmentForImport(int? currentUserId, string accessKey)
        {
            DateTime nowUTC = DateTime.Now;
            AssessmentDetail newAssessment = new AssessmentDetail
            {
                AssessmentName = "New Assessment",
                AssessmentDate = nowUTC,
                CreatorId = currentUserId,
                CreatedDate = nowUTC,
                LastModifiedDate = nowUTC
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
                    AssessmentCreatedDate = _utilities.UtcToLocal(result.AssessmentCreatedDate),
                    AssessmentCreatorId = tmpGuid.ToString(),
                    Assessment_Date = _utilities.UtcToLocal(result.Assessment_Date),
                    Assessment_GUID = result.Assessment_GUID.ToString(),
                    LastModifiedDate = _utilities.UtcToLocal((DateTime)result.LastModifiedDate),
                    Mode = modeResult?.Application_Mode
                };
            }

            return assessment;

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
                assessment.CreatedDate = _utilities.UtcToLocal(result.aa.AssessmentCreatedDate);
                assessment.LastModifiedDate = _utilities.UtcToLocal((DateTime)result.aa.LastModifiedDate);
                assessment.DiagramMarkup = result.aa.Diagram_Markup;
                assessment.DiagramImage = result.aa.Diagram_Image;

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
                    DetermineFeaturesFromData(ref assessment);
                }

                SetAssessmentTypeInfo(assessment);

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
        public void DetermineFeaturesFromData(ref AssessmentDetail assessment)
        {
            var a = assessment;

            var dbAssessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == a.Id);

            if (_context.AVAILABLE_STANDARDS.Any(x => x.Assessment_Id == a.Id))
            {
                assessment.UseStandard = true;
                dbAssessment.UseStandard = true;
                _context.SaveChanges();
            }


            if (_context.ASSESSMENT_DIAGRAM_COMPONENTS.Any(x => x.Assessment_Id == a.Id))
            {

                assessment.UseDiagram = _diagramManager.HasDiagram(a.Id);
                dbAssessment.UseDiagram = assessment.UseDiagram;
                _context.SaveChanges();
            }


            // determine if there are maturity answers and attach maturity models
            var maturityAnswers = _context.ANSWER.Where(x => x.Assessment_Id == a.Id && x.Question_Type.ToLower() == "maturity").ToList();
            if (maturityAnswers.Count > 0)
            {
                assessment.UseMaturity = true;
                dbAssessment.UseMaturity = true;

                if (!_context.AVAILABLE_MATURITY_MODELS.Any(x => x.Assessment_Id == a.Id))
                {

                    // determine the maturity models represented by the questions that have been answered
                    var qqq = _context.MATURITY_QUESTIONS.Where(q => maturityAnswers.Select(x => x.Question_Or_Requirement_Id).Contains(q.Mat_Question_Id)).ToList();
                    var maturityModelIds = qqq.Select(x => x.Maturity_Model_Id).Distinct().ToList();
                    foreach (var modelId in maturityModelIds)
                    {
                        var mm = new AVAILABLE_MATURITY_MODELS()
                        {
                            Assessment_Id = a.Id,
                            model_id = modelId,
                            Selected = true
                        };

                        _context.AVAILABLE_MATURITY_MODELS.Add(mm);

                        // get the newly-attached model for the response
                        assessment.MaturityModel = _maturityBusiness.GetMaturityModel(a.Id);
                    }
                }

                _context.SaveChanges();
            }
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
                _context.ASSESSMENTS.Add(dbAssessment);
                _context.SaveChanges();
                assessmentId = dbAssessment.Assessment_Id;
            }

            dbAssessment.Assessment_Id = assessmentId;
            dbAssessment.AssessmentCreatedDate = assessment.CreatedDate;
            dbAssessment.AssessmentCreatorId = assessment.CreatorId == 0 ? null : assessment.CreatorId;
            dbAssessment.Assessment_Date = assessment.AssessmentDate ?? DateTime.Now;
            dbAssessment.LastModifiedDate = assessment.LastModifiedDate;

            dbAssessment.UseDiagram = assessment.UseDiagram;
            dbAssessment.UseMaturity = assessment.UseMaturity;
            dbAssessment.UseStandard = assessment.UseStandard;

            dbAssessment.Charter = string.IsNullOrEmpty(assessment.Charter) ? "00000" : assessment.Charter.PadLeft(5, '0');
            dbAssessment.CreditUnionName = assessment.CreditUnion;
            dbAssessment.Assets = assessment.Assets.ToString();
            dbAssessment.MatDetail_targetBandOnly = (app_code == "ACET");

            dbAssessment.Diagram_Markup = assessment.DiagramMarkup;
            dbAssessment.Diagram_Image = assessment.DiagramImage;
            dbAssessment.AnalyzeDiagram = false;

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

            if (app_code == "ACET")
            {
                if (assessment.MaturityModel?.ModelName != "ISE")
                {
                    var creditUnion = string.IsNullOrEmpty(assessment.CreditUnion)
                        ? string.Empty
                        : assessment.CreditUnion + " ";
                    assessment.AssessmentName =
                        app_code + " " + dbAssessment.Charter + " " + creditUnion + dbAssessment.Assessment_Date.ToString("MMddyy");
                }
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

            _assessmentUtil.TouchAssessment(assessmentId);

            return assessmentId;
        }


        /// <summary>
        /// Create new headers for IRP calculations
        /// </summary>
        /// <param name="assessmentId"></param>
        public void CreateIrpHeaders(int assessmentId)
        {
            int idOffset = 1;

            // now just properties on an Assessment
            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);

            foreach (IRP_HEADER header in _context.IRP_HEADER)
            {
                IRPSummary summary = new IRPSummary();
                summary.HeaderText = header.Header;

                ASSESSMENT_IRP_HEADER headerInfo = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(h =>
                    h.IRP_HEADER.IRP_Header_Id == header.IRP_Header_Id &&
                    h.ASSESSMENT.Assessment_Id == assessmentId);

                summary.RiskLevel = 0;
                headerInfo = new ASSESSMENT_IRP_HEADER()
                {
                    RISK_LEVEL = 0,
                    IRP_HEADER = header
                };
                headerInfo.ASSESSMENT = assessment;
                if (_context.ASSESSMENT_IRP_HEADER.Count() == 0)
                {
                    headerInfo.HEADER_RISK_LEVEL_ID = header.IRP_Header_Id;
                }
                else
                {
                    headerInfo.HEADER_RISK_LEVEL_ID =
                        _context.ASSESSMENT_IRP_HEADER.Max(i => i.HEADER_RISK_LEVEL_ID) + idOffset;
                    idOffset++;
                }

                summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;

                _context.ASSESSMENT_IRP_HEADER.Add(headerInfo);
            }

            _context.SaveChanges();
        }


        /// <summary>
        /// Default a few things
        /// </summary>
        private void SetDefaultTsaStuff(AssessmentDetail assessment)
        {
            assessment.UseStandard = true;
        }


        /// <summary>
        /// Get all organization types
        /// </summary>
        /// <param></param>
        /// <returns></returns>
        public List<DEMOGRAPHICS_ORGANIZATION_TYPE> GetOrganizationTypes()
        {
            var orgType = new List<DEMOGRAPHICS_ORGANIZATION_TYPE>();
            orgType = _context.DEMOGRAPHICS_ORGANIZATION_TYPE.ToList();

            return orgType;
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

        //public void GetMaturityDetails(ref AssessmentDetail assessment)
        //{
        //    throw new NotImplementedException();
        //}

        //public void GetSelectedStandards(ref AssessmentDetail assessment)
        //{
        //    throw new NotImplementedException();
        //}

        //public void DetermineFeaturesFromData(ref AssessmentDetail assessment)
        //{
        //    throw new NotImplementedException();
        //}

        /// <summary>
        /// Sets the assessment type title and description.
        /// </summary>
        /// <param name="assessment"></param>
        public void SetAssessmentTypeInfo(AssessmentDetail assessment)
        {
            // Check for old assessment with multiple assessment types.
            bool multipleTypes = (assessment.UseStandard && assessment.Standards.Count > 1)
                                || (assessment.UseDiagram && assessment.UseMaturity)
                                || (assessment.UseDiagram && assessment.UseStandard)
                                || (assessment.UseMaturity && assessment.UseStandard);

            if (assessment.UseMaturity)
            {
                // Use shorter names on assessments with multiple types.
                assessment.TypeTitle += ", " + assessment.MaturityModel.ModelTitle;
                assessment.TypeDescription = assessment.MaturityModel.ModelDescription;
            }

            if (assessment.UseStandard)
            {
                GatherSetsInfo(assessment.Standards).ForEach(standard =>
                {
                    // Use shorter names on assessments with multiple types.
                    assessment.TypeTitle += ", " + (multipleTypes ? standard.ShortName : standard.FullName);
                    assessment.TypeDescription = standard.Description;
                });
            }

            if (assessment.UseDiagram)
            {
                assessment.TypeTitle += ", Network Diagram";
                assessment.TypeDescription = "A Network Architecture and Diagram Based assessment. This assessment requires that you build " +
                    "or import an assessment into CSET and creates a question set specifically tailored to your network configuration.";
            }

            if (assessment.TypeTitle != null)
                if (assessment.TypeTitle.IndexOf(",") == 0)
                {
                    assessment.TypeTitle = assessment.TypeTitle.Substring(2);
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
                var set = allSets.Find(set => set.Set_Name == setName);
                processedSets.Add(new SetInfo { FullName = set.Full_Name, ShortName = set.Short_Name, Description = set.Standard_ToolTip });
            }
            return processedSets;
        }

        public class SetInfo
        {
            public string FullName { get; set; }
            public string ShortName { get; set; }
            public string Description { get; set; }
        }

    }
}
