//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Collections.Generic;
using System.Linq;
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessManagers
{
    /// <summary>
    /// Encapsulates functionality related to Assessments.
    /// </summary>
    public class AssessmentManager
    {

        public AssessmentDetail CreateNewAssessment(int currentUserId, bool mode)
        {
            DateTime nowUTC = Utilities.UtcToLocal(DateTime.UtcNow);
            AssessmentDetail newAssessment = new AssessmentDetail
            {
                AssessmentName = mode ? "ACET 00000 " + DateTime.Now.ToString("MMddyy") : "New Assessment",
                AssessmentDate = nowUTC,
                CreatorId = currentUserId,
                CreatedDate = nowUTC,
                LastModifiedDate = nowUTC
            };

            // Commit the new assessment
            int assessment_id = SaveAssessmentDetail(0, newAssessment);
            newAssessment.Id = assessment_id;


            // Add the current user to the new assessment as an admin that has already been 'invited'
            ContactsManager contactManager = new ContactsManager();
            contactManager.AddContactToAssessment(assessment_id, currentUserId, Constants.AssessmentAdminId, true);

            new SalManager().SetDefaultSALs(assessment_id);

            new StandardsManager().PersistSelectedStandards(assessment_id, null);
            CreateIrpHeaders(assessment_id);
            return newAssessment;
        }



        public AssessmentDetail CreateNewAssessmentForImport(int currentUserId)
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
            ContactsManager contactManager = new ContactsManager();
            contactManager.AddContactToAssessment(assessment_id, currentUserId, Constants.AssessmentAdminId, true);
            return newAssessment;
        }

        /// <summary>
        /// Returns a collection of Assessment objects that are connected to the specified user.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public IEnumerable<Assessments_For_User> GetAssessmentsForUser(int userId)
        {
            List<Assessments_For_User> list = new List<Assessments_For_User>();

            using (var db = new CSET_Context())
            {
                // list = db.Assessments_For_User.Where(x => x.UserId == userId).ToList();
                list = db.usp_AssessmentsForUser(userId).ToList();
            }

            return list;
        }

        public AnalyticsAssessment GetAnalyticsAssessmentDetail(int assessmentId)
        {
            AnalyticsAssessment assessment = new AnalyticsAssessment();
            TokenManager tm = new TokenManager();
            string app_code = tm.Payload(Constants.Token_Scope);

            using (var db = new CSET_Context())
            {
                var query = from aa in db.ASSESSMENTS
                            where aa.Assessment_Id == assessmentId
                            select aa;

                int tmpUID = 0;
                Guid tmpGuid = Guid.NewGuid();

                if (int.TryParse(tm.Payload(Constants.Token_UserId), out tmpUID))
                {
                    USERS user = db.USERS.Where(x => x.UserId == tmpUID).FirstOrDefault();
                    if (user != null)
                    {
                        if (user.Id != null)
                        {
                            user.Id = tmpGuid;
                            db.SaveChanges();
                        }
                        else
                        {
                            tmpGuid = user.Id ?? Guid.NewGuid();
                        }
                    }
                }



                var result = query.ToList().FirstOrDefault();
                var modeResult = query.Join(db.STANDARD_SELECTION, x => x.Assessment_Id, y => y.Assessment_Id, (x, y) => y)
                    .FirstOrDefault();

                if (result != null)
                {

                    assessment = new AnalyticsAssessment()
                    {
                        Alias = result.Alias,
                        AssessmentCreatedDate = Utilities.UtcToLocal(result.AssessmentCreatedDate),
                        AssessmentCreatorId = tmpGuid.ToString(),
                        Assessment_Date = Utilities.UtcToLocal(result.Assessment_Date),
                        Assessment_GUID = result.Assessment_GUID.ToString(),
                        LastAccessedDate = Utilities.UtcToLocal((DateTime)result.LastAccessedDate),
                        Mode = modeResult?.Application_Mode
                    };
                }

                return assessment;
            }
        }

        /// <summary>
        /// Returns the details for the specified Assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public AssessmentDetail GetAssessmentDetail(int assessmentId)
        {
            AssessmentDetail assessment = new AssessmentDetail();
            TokenManager tm = new TokenManager();
            string app_code = tm.Payload(Constants.Token_Scope);

            using (var db = new CSET_Context())
            {
                var query = (from ii in db.INFORMATION
                             join aa in db.ASSESSMENTS on ii.Id equals aa.Assessment_Id
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
                    assessment.ExecutiveSummary = result.ii.Executive_Summary;
                    assessment.AssessmentDescription = result.ii.Assessment_Description;
                    assessment.AdditionalNotesAndComments = result.ii.Additional_Notes_And_Comments;
                    assessment.CreatorId = result.aa.AssessmentCreatorId ?? 0;
                    assessment.CreatedDate = Utilities.UtcToLocal(result.aa.AssessmentCreatedDate);
                    assessment.LastModifiedDate = Utilities.UtcToLocal((DateTime)result.aa.LastAccessedDate);
                    assessment.DiagramMarkup = result.aa.Diagram_Markup;
                    assessment.DiagramImage = result.aa.Diagram_Image;

                    assessment.UseStandard = result.aa.UseStandard;
                    if (assessment.UseStandard)
                    {
                        GetSelectedStandards(ref assessment, db);
                    }

                    assessment.UseDiagram = result.aa.UseDiagram;

                    assessment.UseMaturity = result.aa.UseMaturity;
                    if (assessment.UseMaturity)
                    {
                        GetMaturityModelDetails(ref assessment, db);
                    }

                    // for older assessments, if no features are set, look for actual data and set them
                    if (!assessment.UseMaturity && !assessment.UseStandard && !assessment.UseDiagram)
                    {
                        DetermineFeaturesFromData(ref assessment, db);
                    }

                    bool defaultAcet = (app_code == "ACET");
                    assessment.IsAcetOnly = result.ii.IsAcetOnly != null ? result.ii.IsAcetOnly : defaultAcet;

                    assessment.Charter = string.IsNullOrEmpty(result.aa.Charter) ? "" : result.aa.Charter;
                    assessment.CreditUnion = result.aa.CreditUnionName;
                    assessment.Assets = result.aa.Assets;


                    // Fields located on the Overview page
                    assessment.ExecutiveSummary = result.ii.Executive_Summary;
                    assessment.AssessmentDescription = result.ii.Assessment_Description;
                    assessment.AdditionalNotesAndComments = result.ii.Additional_Notes_And_Comments;
                }

                return assessment;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private void GetMaturityModelDetails(ref AssessmentDetail assessment, CSET_Context db)
        {
            int assessmentId = assessment.Id;

            var maturityManager = new MaturityManager();

            assessment.MaturityModel = maturityManager.GetMaturityModel(assessmentId);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessment"></param>
        /// <param name="db"></param>
        private void GetSelectedStandards(ref AssessmentDetail assessment, CSET_Context db)
        {
            var assessmentId = assessment.Id;
            var standardsList = db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected).ToList();
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
        private void DetermineFeaturesFromData(ref AssessmentDetail assessment, CSET_Context db)
        {
            var a = assessment;
            if (db.AVAILABLE_STANDARDS.Any(x => x.Assessment_Id == a.Id))
            {
                assessment.UseStandard = true;
            }


            if (db.ASSESSMENT_DIAGRAM_COMPONENTS.Any(x => x.Assessment_Id == a.Id))
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                assessment.UseDiagram = dm.HasDiagram(a.Id);
            }

            // determine if there are maturity answers and attach maturity models
            var maturityAnswers = db.ANSWER.Where(x => x.Assessment_Id == a.Id && x.Question_Type.ToLower() == "maturity").ToList();
            if (maturityAnswers.Count > 0)
            {
                assessment.UseMaturity = true;

                // determine the maturity models represented by the questions that have been answered
                var qqq = db.MATURITY_QUESTIONS.Where(q => maturityAnswers.Select(x => x.Question_Or_Requirement_Id).Contains(q.Mat_Question_Id)).ToList();
                var maturityModelIds = qqq.Select(x => x.Maturity_Model_Id).Distinct().ToList();
                foreach (var modelId in maturityModelIds)
                {
                    var mm = new AVAILABLE_MATURITY_MODELS()
                    {
                        Assessment_Id = a.Id,
                        model_id = modelId,
                        Selected = true
                    };

                    db.AVAILABLE_MATURITY_MODELS.Add(mm);
                    db.SaveChanges();

                    // get the newly-attached model for the response
                    var mmm = new MaturityManager();
                    assessment.MaturityModel = mmm.GetMaturityModel(a.Id);
                }
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
            using (var db = new DataLayerCore.Model.CSET_Context())
            {
                TokenManager tm = new TokenManager();
                string app_code = tm.Payload(Constants.Token_Scope);

                // Add or update the ASSESSMENTS record
                var dbAssessment = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

                if (dbAssessment == null)
                {
                    dbAssessment = new ASSESSMENTS();
                    db.ASSESSMENTS.Add(dbAssessment);
                    db.SaveChanges();
                    assessmentId = dbAssessment.Assessment_Id;
                }

                dbAssessment.Assessment_Id = assessmentId;
                dbAssessment.AssessmentCreatedDate = assessment.CreatedDate;
                dbAssessment.AssessmentCreatorId = assessment.CreatorId;
                dbAssessment.Assessment_Date = assessment.AssessmentDate ?? DateTime.Now;
                dbAssessment.LastAccessedDate = assessment.LastModifiedDate;

                dbAssessment.UseDiagram = assessment.UseDiagram;
                dbAssessment.UseMaturity = assessment.UseMaturity;
                dbAssessment.UseStandard = assessment.UseStandard;

                dbAssessment.Charter = string.IsNullOrEmpty(assessment.Charter) ? "00000" : assessment.Charter.PadLeft(5, '0');
                dbAssessment.CreditUnionName = assessment.CreditUnion;
                dbAssessment.Assets = assessment.Assets;
                dbAssessment.MatDetail_targetBandOnly = (app_code == "ACET");

                dbAssessment.Diagram_Markup = assessment.DiagramMarkup;
                dbAssessment.Diagram_Image = assessment.DiagramImage;
                dbAssessment.AnalyzeDiagram = false;

                db.ASSESSMENTS.AddOrUpdate(dbAssessment, x => x.Assessment_Id);
                db.SaveChanges();


                var user = db.USERS.FirstOrDefault(x => x.UserId == dbAssessment.AssessmentCreatorId);


                var dbInformation = db.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
                if (dbInformation == null)
                {
                    dbInformation = new INFORMATION()
                    {
                        Id = assessmentId
                    };
                }

                if (app_code == "ACET")
                {
                    assessment.AssessmentName =
                        app_code + " " + dbAssessment.Charter + " " + DateTime.Now.ToString("MMddyy");
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

                db.INFORMATION.AddOrUpdate(dbInformation, x => x.Id);
                db.SaveChanges();


                // persist maturity data
                if (assessment.UseMaturity)
                {
                    SalManager salManager = new SalManager();
                    salManager.SetDefaultSAL_IfNotSet(assessmentId);
                }

                AssessmentUtil.TouchAssessment(assessmentId);

                return assessmentId;
            }
        }

        /// <summary>
        /// Create new headers for IRP calculations
        /// </summary>
        /// <param name="assessmentId"></param>
        public void CreateIrpHeaders(int assessmentId)
        {
            int idOffset = 1;
            using (var db = new CSET_Context())
            {
                // now just properties on an Assessment
                ASSESSMENTS assessment = db.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);

                foreach (IRP_HEADER header in db.IRP_HEADER)
                {
                    IRPSummary summary = new IRPSummary();
                    summary.HeaderText = header.Header;

                    ASSESSMENT_IRP_HEADER headerInfo = db.ASSESSMENT_IRP_HEADER.FirstOrDefault(h =>
                        h.IRP_HEADER_.IRP_Header_Id == header.IRP_Header_Id &&
                        h.ASSESSMENT_.Assessment_Id == assessmentId);

                    summary.RiskLevel = 0;
                    headerInfo = new ASSESSMENT_IRP_HEADER()
                    {
                        RISK_LEVEL = 0,
                        IRP_HEADER_ = header
                    };
                    headerInfo.ASSESSMENT_ = assessment;
                    if (db.ASSESSMENT_IRP_HEADER.Count() == 0)
                    {
                        headerInfo.HEADER_RISK_LEVEL_ID = header.IRP_Header_Id;
                    }
                    else
                    {
                        headerInfo.HEADER_RISK_LEVEL_ID =
                            db.ASSESSMENT_IRP_HEADER.Max(i => i.HEADER_RISK_LEVEL_ID) + idOffset;
                        idOffset++;
                    }

                    summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;

                    db.ASSESSMENT_IRP_HEADER.Add(headerInfo);
                }

                db.SaveChanges();
            }
        }

        /// <summary>
        /// Returns the Demographics instance for the assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Demographics GetDemographics(int assessmentId)
        {
            Demographics demographics = new Demographics
            {
                AssessmentId = assessmentId
            };

            using (var db = new CSET_Context())
            {
                var query = from ddd in db.DEMOGRAPHICS
                            from ds in db.DEMOGRAPHICS_SIZE.Where(x => x.Size == ddd.Size).DefaultIfEmpty()
                            from dav in db.DEMOGRAPHICS_ASSET_VALUES.Where(x => x.AssetValue == ddd.AssetValue).DefaultIfEmpty()
                            where ddd.Assessment_Id == assessmentId
                            select new { ddd, ds, dav };


                var hit = query.FirstOrDefault();
                if (hit != null)
                {
                    demographics.SectorId = hit.ddd.SectorId;
                    demographics.IndustryId = hit.ddd.IndustryId;
                    demographics.AssetValue = hit.dav?.DemographicsAssetId;
                    demographics.Size = hit.ds?.DemographicId;
                    demographics.PointOfContact = hit.ddd?.PointOfContact;
                    demographics.Agency = hit.ddd?.Agency;
                    demographics.Facilitator = hit.ddd?.Facilitator;
                    demographics.IsScoped = hit.ddd?.IsScoped != false;
                    demographics.OrganizationName = hit.ddd?.OrganizationName;
                    demographics.OrganizationType = hit.ddd?.OrganizationType;

                }

                return demographics;
            }
        }

        /// <summary>
        /// Get all organization types
        /// </summary>
        /// <param></param>
        /// <returns></returns>
        public List<DEMOGRAPHICS_ORGANIZATION_TYPE> GetOrganizationTypes()
        {
            var orgType = new List<DEMOGRAPHICS_ORGANIZATION_TYPE>();
            using (var db = new CSET_Context())
            {
                orgType = db.DEMOGRAPHICS_ORGANIZATION_TYPE.ToList();
            }

            return orgType;
        }

        /// <summary>
        /// Returns the Demographics instance for the assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public AnalyticsDemographic GetAnonymousDemographics(int assessmentId)
        {
            AnalyticsDemographic demographics = new AnalyticsDemographic();

            using (var db = new CSET_Context())
            {
                var query = from ddd in db.DEMOGRAPHICS
                            from s in db.SECTOR.Where(x => x.SectorId == ddd.SectorId).DefaultIfEmpty()
                            from i in db.SECTOR_INDUSTRY.Where(x => x.IndustryId == ddd.IndustryId).DefaultIfEmpty()
                            from ds in db.DEMOGRAPHICS_SIZE.Where(x => x.Size == ddd.Size).DefaultIfEmpty()
                            from dav in db.DEMOGRAPHICS_ASSET_VALUES.Where(x => x.AssetValue == ddd.AssetValue).DefaultIfEmpty()
                            where ddd.Assessment_Id == assessmentId
                            select new { ddd, ds, dav, s, i };


                var hit = query.FirstOrDefault();
                if (hit != null)
                {
                    if (hit.i != null)
                    {
                        demographics.IndustryId = hit.i != null ? hit.i.IndustryId : 0;
                        demographics.IndustryName = hit.i.IndustryName ?? string.Empty;
                    }
                    if (hit.s != null)
                    {
                        demographics.SectorId = hit.s != null ? hit.s.SectorId : 0;
                        demographics.SectorName = hit.s.SectorName ?? string.Empty;

                    }
                    if (hit.ddd != null)
                    {

                        demographics.AssetValue = hit.ddd.AssetValue ?? string.Empty;
                        demographics.Size = hit.ddd.Size ?? string.Empty;
                    }
                }

                return demographics;
            }
        }




        /// <summary>
        /// Persists data to the DEMOGRAPHICS table.
        /// </summary>
        /// <param name="demographics"></param>
        /// <returns></returns>
        public int SaveDemographics(Demographics demographics)
        {
            var db = new CSET_Context();

            // Convert Size and AssetValue from their keys to the strings they are stored as
            string assetValue = db.DEMOGRAPHICS_ASSET_VALUES.Where(dav => dav.DemographicsAssetId == demographics.AssetValue).FirstOrDefault()?.AssetValue;
            string assetSize = db.DEMOGRAPHICS_SIZE.Where(dav => dav.DemographicId == demographics.Size).FirstOrDefault()?.Size;

            // If the user selected nothing for sector or industry, store a null - 0 violates foreign key
            if (demographics.SectorId == 0)
            {
                demographics.SectorId = null;
            }

            if (demographics.IndustryId == 0)
            {
                demographics.IndustryId = null;
            }

            // Add or update the DEMOGRAPHICS record
            var dbDemographics = new DEMOGRAPHICS()
            {
                Assessment_Id = demographics.AssessmentId,
                IndustryId = demographics.IndustryId,
                SectorId = demographics.SectorId,
                Size = assetSize,
                AssetValue = assetValue,
                Facilitator = demographics.Facilitator == 0 ? null : demographics.Facilitator,
                PointOfContact = demographics.PointOfContact == 0 ? null : demographics.PointOfContact,
                IsScoped = demographics.IsScoped,
                Agency = demographics.Agency,
                OrganizationType = demographics.OrganizationType == 0 ? null : demographics.OrganizationType,
                OrganizationName = demographics.OrganizationName
            };

            db.DEMOGRAPHICS.AddOrUpdate(dbDemographics, x => x.Assessment_Id);
            db.SaveChanges();
            demographics.AssessmentId = dbDemographics.Assessment_Id;

            AssessmentUtil.TouchAssessment(dbDemographics.Assessment_Id);

            return demographics.AssessmentId;
        }


        /// <summary>
        /// Returns a boolean indicating if the current User is attached to the specified Assessment.
        /// The authentication token is automatically read and the user is determined from it.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public bool IsCurrentUserOnAssessment(int assessmentId)
        {
            int currentUserId = Auth.GetUserId();

            using (var db = new CSET_Context())
            {
                int countAC = db.ASSESSMENT_CONTACTS.Where(ac => ac.Assessment_Id == assessmentId
                && ac.UserId == currentUserId).Count();

                return (countAC > 0);
            }
        }

        /// <summary>
        /// Get assessment from given assessment Id
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public ASSESSMENTS GetAssessmentById(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                return db.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            }
        }
    }
}


