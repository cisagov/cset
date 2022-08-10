using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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


        public async Task<AssessmentDetail> CreateNewAssessment(int currentUserId, string workflow)
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
            int assessment_id = await SaveAssessmentDetail(0, newAssessment);
            newAssessment.Id = assessment_id;

            // Add the current user to the new assessment as an admin that has already been 'invited'
            _contactBusiness.AddContactToAssessment(assessment_id, currentUserId, Constants.Constants.AssessmentAdminId, true);


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


            await CreateIrpHeaders(assessment_id);

            return newAssessment;
        }



        public async Task<AssessmentDetail> CreateNewAssessmentForImport(int currentUserId)
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
            int assessment_id = await SaveAssessmentDetail(0, newAssessment);
            newAssessment.Id = assessment_id;


            // Add the current user to the new assessment as an admin that has already been 'invited'
            _contactBusiness.AddContactToAssessment(assessment_id, currentUserId, Constants.Constants.AssessmentAdminId, true);
            return newAssessment;
        }

        /// <summary>
        /// Returns a collection of Assessment objects that are connected to the specified user.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public async Task<IEnumerable<usp_Assessments_For_UserResult>> GetAssessmentsForUser(int userId)
        {            
            var list = await _context.usp_AssessmentsForUser(userId);
            return list;
        }

        /// <summary>
        /// Returns a collection of Assessment objects that are connected to the specified user.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public async Task<IEnumerable<usp_Assessments_Completion_For_UserResult>> GetAssessmentsCompletionForUser(int userId)
        {            
            var list = await _context.usp_AssessmentsCompletionForUser(userId);
            return list;
        }


        public async Task<AnalyticsAssessment> GetAnalyticsAssessmentDetail(int assessmentId)
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
                USERS user = await _context.USERS.Where(x => x.UserId == tmpUID).FirstOrDefaultAsync();
                if (user != null)
                {
                    if (user.Id != null)
                    {
                        user.Id = tmpGuid;
                        await _context.SaveChangesAsync();
                    }
                    else
                    {
                        tmpGuid = user.Id ?? Guid.NewGuid();
                    }
                }
            }




            var resultList = await query.ToListAsync();
            var result = resultList.FirstOrDefault();
            var modeResult = resultList.Join(await _context.STANDARD_SELECTION.ToListAsync(), x => x.Assessment_Id, y => y.Assessment_Id, (x, y) => y);

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
                    Mode =  modeResult?.FirstOrDefault().Application_Mode
                };
            }

            return assessment;

        }

        /// <summary>
        /// Returns the details for the specified Assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public async Task<AssessmentDetail> GetAssessmentDetail(int assessmentId, string token = "")
        {
            AssessmentDetail assessment = new AssessmentDetail();
            if (!string.IsNullOrEmpty(token))
                await _tokenManager.Init(token);
            string app_code = _tokenManager.Payload(Constants.Constants.Token_Scope);

            var query = (from ii in _context.INFORMATION
                         join aa in _context.ASSESSMENTS on ii.Id equals aa.Assessment_Id
                         where ii.Id == assessmentId
                         select new { ii, aa });

            var resultList = await query.ToListAsync();
            if (resultList.Any())
            {

                var result = resultList.FirstOrDefault();
                assessment.Id = result.aa.Assessment_Id;
                assessment.AssessmentName = result.ii.Assessment_Name;
                assessment.AssessmentDate = result.aa.Assessment_Date;
                assessment.FacilityName = result.ii.Facility_Name;
                assessment.CityOrSiteName = result.ii.City_Or_Site_Name;
                assessment.StateProvRegion = result.ii.State_Province_Or_Region;
                assessment.ExecutiveSummary = result.ii.Executive_Summary;
                assessment.AssessmentDescription = result.ii.Assessment_Description;
                assessment.AdditionalNotesAndComments = result.ii.Additional_Notes_And_Comments;
                assessment.CreatorId = result.aa.AssessmentCreatorId ?? 0;
                assessment.CreatedDate = _utilities.UtcToLocal(result.aa.AssessmentCreatedDate);
                assessment.LastModifiedDate = _utilities.UtcToLocal((DateTime)result.aa.LastModifiedDate);
                assessment.DiagramMarkup = result.aa.Diagram_Markup;
                assessment.DiagramImage = result.aa.Diagram_Image;

                assessment.UseStandard = result.aa.UseStandard;
                if (assessment.UseStandard)
                {
                    assessment = await GetSelectedStandards(assessment);
                }

                assessment.UseDiagram = result.aa.UseDiagram;

                assessment.UseMaturity = result.aa.UseMaturity;
                if (assessment.UseMaturity)
                {
                    assessment = await GetMaturityModelDetails(assessment);
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

                // for older assessments, if no features are set, look for actual data and set them
                if (!assessment.UseMaturity && !assessment.UseStandard && !assessment.UseDiagram)
                {
                    assessment = await DetermineFeaturesFromData(assessment);
                }

                bool defaultAcet = (app_code == "ACET");
                assessment.IsAcetOnly = result.ii.IsAcetOnly != null ? result.ii.IsAcetOnly : defaultAcet;

                assessment.BaselineAssessmentId = result.ii.Baseline_Assessment_Id;
                if (assessment.BaselineAssessmentId != null)
                {
                    var baseInfo = await _context.INFORMATION.FirstOrDefaultAsync(x => x.Id == assessment.BaselineAssessmentId);
                    assessment.BaselineAssessmentName = baseInfo.Assessment_Name;
                }


                // ACET-specific fields
                assessment.Charter = string.IsNullOrEmpty(result.aa.Charter) ? "" : result.aa.Charter;
                assessment.CreditUnion = result.aa.CreditUnionName;
                assessment.Assets = result.aa.Assets != null ? int.Parse(result.aa.Assets) : 0;


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
        public async Task<DateTime> GetLastModifiedDateUtc(int assessmentId)
        {
            string app_code = _tokenManager.Payload(Constants.Constants.Token_Scope);

            var assessment = await _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefaultAsync();
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
        public async Task<AssessmentDetail> GetMaturityModelDetails(AssessmentDetail assessment)
        {
            int assessmentId = assessment.Id;

            assessment.MaturityModel = await _maturityBusiness.GetMaturityModel(assessmentId);

            return assessment;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessment"></param>
        /// <param name="db"></param>
        public async Task<AssessmentDetail> GetSelectedStandards(AssessmentDetail assessment)
        {
            var assessmentId = assessment.Id;
            var standardsList = await _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected).ToListAsync();
            assessment.Standards = new List<string>();
            foreach (var s in standardsList)
            {
                assessment.Standards.Add(s.Set_Name);
            }

            return assessment;
        }


        /// <summary>
        /// Set features based on existence of data.  This is used for assessments that were
        /// created prior to incorporating features into the assessment data model.
        /// </summary>
        /// <param name="assessment"></param>
        public async Task<AssessmentDetail> DetermineFeaturesFromData(AssessmentDetail assessment)
        {
            var a = assessment;

            var dbAssessment = await _context.ASSESSMENTS.FirstOrDefaultAsync(x => x.Assessment_Id == a.Id);

            if (await _context.AVAILABLE_STANDARDS.AnyAsync(x => x.Assessment_Id == a.Id))
            {
                assessment.UseStandard = true;
                dbAssessment.UseStandard = true;
                await _context.SaveChangesAsync();
            }


            if (await _context.ASSESSMENT_DIAGRAM_COMPONENTS.AnyAsync(x => x.Assessment_Id == a.Id))
            {

                assessment.UseDiagram = _diagramManager.HasDiagram(a.Id);
                dbAssessment.UseDiagram = assessment.UseDiagram;
                await _context.SaveChangesAsync();
            }


            // determine if there are maturity answers and attach maturity models
            var maturityAnswers = await _context.ANSWER.Where(x => x.Assessment_Id == a.Id && x.Question_Type.ToLower() == "maturity").ToListAsync();
            if (maturityAnswers.Count > 0)
            {
                assessment.UseMaturity = true;
                dbAssessment.UseMaturity = true;

                if (! await _context.AVAILABLE_MATURITY_MODELS.AnyAsync(x => x.Assessment_Id == a.Id))
                {

                    // determine the maturity models represented by the questions that have been answered
                    var qqq = await _context.MATURITY_QUESTIONS.Where(q => maturityAnswers
                    .Select(x => x.Question_Or_Requirement_Id).Contains(q.Mat_Question_Id)).ToListAsync();

                    var maturityModelIds = qqq.Select(x => x.Maturity_Model_Id).Distinct().ToList();
                    foreach (var modelId in maturityModelIds)
                    {
                        var mm = new AVAILABLE_MATURITY_MODELS()
                        {
                            Assessment_Id = a.Id,
                            model_id = modelId,
                            Selected = true
                        };

                        await _context.AVAILABLE_MATURITY_MODELS.AddAsync(mm);

                        // get the newly-attached model for the response
                        assessment.MaturityModel = await _maturityBusiness.GetMaturityModel(a.Id);
                    }
                }

                await _context.SaveChangesAsync();
            }

            return a;
        }


        /// <summary>
        /// Persists data to the ASSESSMENTS and INFORMATION tables.
        /// Date fields should be converted to UTC before sending the Assessment
        /// to this method.
        /// </summary>
        /// <param name="assessment"></param>
        /// <returns></returns>
        public async Task<int> SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment)
        {            
            string app_code = _tokenManager.Payload(Constants.Constants.Token_Scope);

            // Add or update the ASSESSMENTS record
            var dbAssessment = await _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefaultAsync();

            if (dbAssessment == null)
            {
                dbAssessment = new ASSESSMENTS();
                await _context.ASSESSMENTS.AddAsync(dbAssessment);
                await _context.SaveChangesAsync();
                assessmentId = dbAssessment.Assessment_Id;
            }

            dbAssessment.Assessment_Id = assessmentId;
            dbAssessment.AssessmentCreatedDate = assessment.CreatedDate;
            dbAssessment.AssessmentCreatorId = assessment.CreatorId == 0 ? null:assessment.CreatorId;
            dbAssessment.Assessment_Date = assessment.AssessmentDate ?? DateTime.Now;
            dbAssessment.LastModifiedDate = assessment.LastModifiedDate;

            dbAssessment.UseDiagram = assessment.UseDiagram;
            dbAssessment.UseMaturity = assessment.UseMaturity;
            dbAssessment.UseStandard = assessment.UseStandard;

            dbAssessment.Charter = string.IsNullOrEmpty(assessment.Charter) ? "00000" : assessment.Charter.PadLeft(5, '0');
            dbAssessment.CreditUnionName = assessment.CreditUnion;
            dbAssessment.Assets = assessment.Assets != null ? assessment.Assets.ToString() : null;
            dbAssessment.MatDetail_targetBandOnly = (app_code == "ACET");

            dbAssessment.Diagram_Markup = assessment.DiagramMarkup;
            dbAssessment.Diagram_Image = assessment.DiagramImage;
            dbAssessment.AnalyzeDiagram = false;
            /*
             //TODO:  create a base class and inject the DbContext class into it and create async Update method: 
            EntityBaseRepository<T>:IEntityBaseRepository<T> where T: class, IEntityBase, new()  
             public async Task UpdateAsync(int id, T entity)
             {
                EntityEntry entityEntry = _context.Entry<T>(entity);
                entityEntry.State = EntityState.Modified;
             }
             
             */
            _context.ASSESSMENTS.Update(dbAssessment);//i think this will get ignored by EF TBH...
            await _context.SaveChangesAsync();


            var user = await _context.USERS.FirstOrDefaultAsync(x => x.UserId == dbAssessment.AssessmentCreatorId);


            var dbInformation = await _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefaultAsync();
            if (dbInformation == null)
            {
                dbInformation = new INFORMATION()
                {
                    Id = assessmentId,
                    Assessment_Name = ""
                };
                await _context.INFORMATION.AddAsync(dbInformation);
                await _context.SaveChangesAsync();
            }

            if (app_code == "ACET")
            {
                var creditUnion = string.IsNullOrEmpty(assessment.CreditUnion)
                    ? string.Empty
                    : assessment.CreditUnion + " ";
                assessment.AssessmentName =
                    app_code + " " + dbAssessment.Charter + " " + creditUnion + dbAssessment.Assessment_Date.ToString("MMddyy");
            }

            // add or update the INFORMATION record
            dbInformation.Assessment_Name = assessment.AssessmentName;
            dbInformation.Facility_Name = assessment.FacilityName;
            dbInformation.City_Or_Site_Name = assessment.CityOrSiteName;
            dbInformation.State_Province_Or_Region = assessment.StateProvRegion;
            dbInformation.Executive_Summary = assessment.ExecutiveSummary;
            dbInformation.Assessment_Description = assessment.AssessmentDescription;
            dbInformation.Additional_Notes_And_Comments = assessment.AdditionalNotesAndComments;
            dbInformation.IsAcetOnly = assessment.IsAcetOnly;
            dbInformation.Workflow = assessment.Workflow;

            _context.INFORMATION.Update(dbInformation);//I think EF will ignore this TBH (see above TODO in case)
            await _context.SaveChangesAsync();


            // persist maturity data
            if (assessment.UseMaturity)
            {
                await _maturityBusiness.PersistSelectedMaturityModel(assessmentId, assessment.MaturityModel?.ModelName);
            }
            else
            {
               await _maturityBusiness.ClearMaturityModel(assessmentId);
            }

            await _assessmentUtil.TouchAssessment(assessmentId);

            return assessmentId;
        }


        /// <summary>
        /// Create new headers for IRP calculations
        /// </summary>
        /// <param name="assessmentId"></param>
        public async Task CreateIrpHeaders(int assessmentId)
        {
            int idOffset = 1;

            // now just properties on an Assessment
            ASSESSMENTS assessment = await _context.ASSESSMENTS.FirstOrDefaultAsync(a => a.Assessment_Id == assessmentId);

            var headerList = await _context.IRP_HEADER.ToListAsync();
            foreach (IRP_HEADER header in headerList)
            {
                IRPSummary summary = new IRPSummary();
                summary.HeaderText = header.Header;

                ASSESSMENT_IRP_HEADER headerInfo = await _context.ASSESSMENT_IRP_HEADER.FirstOrDefaultAsync(h =>
                    h.IRP_HEADER.IRP_Header_Id == header.IRP_Header_Id &&
                    h.ASSESSMENT.Assessment_Id == assessmentId);

                summary.RiskLevel = 0;
                headerInfo = new ASSESSMENT_IRP_HEADER()
                {
                    RISK_LEVEL = 0,
                    IRP_HEADER = header
                };
                headerInfo.ASSESSMENT = assessment;
                if (await _context.ASSESSMENT_IRP_HEADER.CountAsync() == 0)
                {
                    headerInfo.HEADER_RISK_LEVEL_ID = header.IRP_Header_Id;
                }
                else
                {
                    headerInfo.HEADER_RISK_LEVEL_ID =
                        await _context.ASSESSMENT_IRP_HEADER.MaxAsync(i => i.HEADER_RISK_LEVEL_ID) + idOffset;
                    idOffset++;
                }

                summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;

                await _context.ASSESSMENT_IRP_HEADER.AddAsync(headerInfo);
            }

            await _context.SaveChangesAsync();
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
        public async Task<List<DEMOGRAPHICS_ORGANIZATION_TYPE>> GetOrganizationTypes()
        {
            
            var orgType = await _context.DEMOGRAPHICS_ORGANIZATION_TYPE.ToListAsync();

            return orgType;
        }

        /// <summary>
        /// Returns a boolean indicating if the current User is attached to the specified Assessment.
        /// The authentication token is automatically read and the user is determined from it.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public async Task<bool> IsCurrentUserOnAssessment(int assessmentId)
        {
            int currentUserId = _tokenManager.GetUserId();

            int countAC = await _context.ASSESSMENT_CONTACTS.Where(ac => ac.Assessment_Id == assessmentId
            && ac.UserId == currentUserId).CountAsync();

            return (countAC > 0);
        }

        /// <summary>
        /// Get assessment from given assessment Id
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public async Task<ASSESSMENTS> GetAssessmentById(int assessmentId)
        {
            return await _context.ASSESSMENTS.FirstOrDefaultAsync(a => a.Assessment_Id == assessmentId);
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
        /// Get all of the available icon paths for assessment selection cards
        /// </summary>
        /// <returns></returns>
        public async Task<List<ASSESSMENT_ICONS>> GetAllAssessmentIcons() 
        {
            return await _context.ASSESSMENT_ICONS.ToListAsync();
        }
    }
}
