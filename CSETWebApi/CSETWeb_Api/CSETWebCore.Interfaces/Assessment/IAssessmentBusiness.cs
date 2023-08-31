//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Assessment
{
    public interface IAssessmentBusiness
    {
        AssessmentDetail CreateNewAssessment(int? currentUserId, string workflow, Guid galleryGuid);
        AssessmentDetail CreateNewAssessmentForImport(int? currentUserId, string accessKey);
        IEnumerable<usp_Assessments_For_UserResult> GetAssessmentsForUser(int userId);
        IEnumerable<usp_Assessments_For_UserResult> GetAssessmentsForAccessKey(string accessKey);
        AnalyticsAssessment GetAnalyticsAssessmentDetail(int assessmentId);
        AssessmentDetail GetAssessmentDetail(int assessmentId, string token = "");
        void GetMaturityModelDetails(ref AssessmentDetail assessment);
        void GetSelectedStandards(ref AssessmentDetail assessment);
        void SetFeaturesOnAssessmentRecord(int assessmentId);
        int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment);
        void CreateIrpHeaders(int assessmentId);
        List<DEMOGRAPHICS_ORGANIZATION_TYPE> GetOrganizationTypes();
        bool IsCurrentUserOnAssessment(int assessmentId);
        ASSESSMENTS GetAssessmentById(int assessmentId);
        DateTime GetLastModifiedDateUtc(int assessmentId);
        IEnumerable<usp_Assessments_Completion_For_UserResult> GetAssessmentsCompletionForUser(int userId);
        IEnumerable<usp_Assessments_Completion_For_UserResult> GetAssessmentsCompletionForAccessKey(string accessKey);

        IList<string> GetNames(int id1, int id2, int? id3, int? id4, int? id5, int? id6, int? id7, int? id8, int? id9, int? id10);

        string GetOtherRemarks(int assessmentId);
        void SaveOtherRemarks(int assessmentId, string remark);
    }
}
