//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Observations;
using CSETWebCore.Model.Document;


namespace CSETWebCore.Interfaces.Assessment
{
    public interface IAssessmentBusiness
    {
        AssessmentDetail CreateNewAssessment(int? currentUserId, string workflow, GalleryConfig config);
        int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment);
        AssessmentDetail CreateNewAssessmentForImport(int? currentUserId, string accessKey, Guid assessmentGuid);
        IEnumerable<usp_Assessments_For_UserResult> GetAssessmentsForUser(int userId);
        IEnumerable<usp_Assessments_For_UserResult> GetAssessmentsForAccessKey(string accessKey);
        AnalyticsAssessment GetAnalyticsAssessmentDetail(int assessmentId);
        AssessmentDetail GetAssessmentDetail(int assessmentId, string token = "");
        void GetMaturityModelDetails(ref AssessmentDetail assessment);
        void GetSelectedStandards(ref AssessmentDetail assessment);
        void SetFeaturesOnAssessmentRecord(int assessmentId);

        List<DEMOGRAPHICS_ORGANIZATION_TYPE> GetOrganizationTypes();
        bool IsCurrentUserOnAssessment(int assessmentId);
        ASSESSMENTS GetAssessmentById(int assessmentId);
        DateTime GetLastModifiedDateUtc(int assessmentId);
        IEnumerable<usp_Assessments_Completion_For_UserResult> GetAssessmentsCompletionForUser(int userId);
        IEnumerable<usp_Assessments_Completion_For_UserResult> GetAssessmentsCompletionForAccessKey(string accessKey);

        IList<string> GetNames(int id1, int id2, int? id3, int? id4, int? id5, int? id6, int? id7, int? id8, int? id9, int? id10);

        string GetOtherRemarks(int assessmentId);
        void SaveOtherRemarks(int assessmentId, string remark);
        void clearFirstTime(int userid, int assessmentId);

        void MoveHydroActionsOutOfIseActions();
        IEnumerable<MergeObservation> GetAssessmentObservations(int id1, int id2, int? id3, int? id4, int? id5, int? id6, int? id7, int? id8, int? id9, int? id10);
        IEnumerable<MergeDocuments> GetAssessmentDocuments(int id1, int id2, int? id3, int? id4, int? id5, int? id6, int? id7, int? id8, int? id9, int? id10);

    }
}
