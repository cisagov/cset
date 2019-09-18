//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
 
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWeb_Api.BusinessLogic.Models;

namespace CSETWeb_Api.BusinessManagers
{
    /// <summary>
    /// Encapsulates functionality related to Assessments.
    /// </summary>
    public class AssessmentManager
    {

        public AssessmentDetail CreateNewAssessment(int currentUserId)
        {
            DateTime nowUTC = Utilities.UtcToLocal(DateTime.UtcNow);
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

            new SalManager().SetDefaultSALs(assessment_id);

            new StandardsManager().PersistSelectedStandards(assessment_id, new List<string> { "***DEFAULT***" });
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
        public IEnumerable<Assessment> GetAssessmentsForUser(int userId)
        {
            List<Assessment> list = new List<Assessment>();

            using (var db = new CSET_Context())
            {
                var query = (from uu in db.USERS
                             join ac in db.ASSESSMENT_CONTACTS on uu.UserId equals ac.UserId
                             join aa in db.ASSESSMENTS on ac.Assessment_Id equals aa.Assessment_Id
                             join ii in db.INFORMATION on aa.Assessment_Id equals ii.Id
                             join cc in db.USERS on aa.AssessmentCreatorId equals cc.UserId
                             where uu.UserId == userId

                             select new
                             {
                                 ID = aa.Assessment_Id,
                                 AssessmentName = ii.Assessment_Name,
                                 StartDate = aa.AssessmentCreatedDate,
                                 CreatorName = cc.FirstName + " " + cc.LastName,
                                 LastModifiedDate = aa.LastAccessedDate
                             });

                var hits = query.ToList();
                foreach (var h in hits)
                {
                    Assessment a = new Assessment
                    {
                        AssessmentId = h.ID,
                        AssessmentName = h.AssessmentName,
                        AssessmentCreatedDate = Utilities.UtcToLocal(h.StartDate),
                        CreatorName = h.CreatorName
                    };

                    if (h.LastModifiedDate != null)
                    {
                        a.LastModifiedDate = Utilities.UtcToLocal((DateTime)h.LastModifiedDate);
                    }

                    // See if any of the assessment's active answers are marked for review
                    AnswerManager ansMan = new AnswerManager(a.AssessmentId);
                    List<int> myAnswerIds = ansMan.ActiveAnswerIds();
                    a.MarkedForReview = db.ANSWER.Where(ans => myAnswerIds.Contains(ans.Answer_Id) && (ans.Mark_For_Review ?? false)).Count() > 0;

                    list.Add(a);
                }
            }

            return list;
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
        /// Persists data to the ASSESSMENTS and INFORMATION tables.
        /// Date fields should be converted to UTC before sending the Assessment
        /// to this method.
        /// </summary>
        /// <param name="assessment"></param>
        /// <returns></returns>
        public int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment)
        {
            var db = new DataLayerCore.Model.CSET_Context();
            TokenManager tm = new TokenManager();
            string app_code = tm.Payload(Constants.Token_Scope);
            // Add or update the ASSESSMENT record
            var dbAssessment = new ASSESSMENTS()
            {
                Assessment_Id = assessment.Id,
                AssessmentCreatedDate = assessment.CreatedDate,
                AssessmentCreatorId = assessment.CreatorId,
                Assessment_Date = assessment.AssessmentDate??DateTime.Now,
                LastAccessedDate = assessment.LastModifiedDate,
                Charter = string.IsNullOrEmpty(assessment.Charter) ? string.Empty : assessment.Charter.PadLeft(5,'0'),
                CreditUnionName = assessment.CreditUnion,
                Assets = assessment.Assets, 
                MatDetail_targetBandOnly = app_code == "ACET"
            };

            db.ASSESSMENTS.AddOrUpdate( dbAssessment, x=> x.Assessment_Id);

            db.SaveChanges();
            assessmentId = dbAssessment.Assessment_Id;
            var user = db.USERS.FirstOrDefault(x => x.UserId == dbAssessment.AssessmentCreatorId);
            // then use its key for the INFORMATION record
            var dbInfo = new INFORMATION
            {
                Id = assessmentId,
                Assessment_Name = assessment.AssessmentName,                
                Facility_Name = assessment.FacilityName,
                City_Or_Site_Name = assessment.CityOrSiteName,
                State_Province_Or_Region = assessment.StateProvRegion,
                Executive_Summary = assessment.ExecutiveSummary,
                Assessment_Description = assessment.AssessmentDescription,
                Additional_Notes_And_Comments = assessment.AdditionalNotesAndComments, 
                IsAcetOnly = assessment.IsAcetOnly
            };

            db.INFORMATION.AddOrUpdate( dbInfo, x=> x.Id);

            db.SaveChanges();


            AssessmentUtil.TouchAssessment(assessmentId);
            

            return dbInfo.Id;
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
                AssetValue = assetValue
            };

            db.DEMOGRAPHICS.AddOrUpdate( dbDemographics, x=> x.Assessment_Id);
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


