
using System;
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Assessment
{
    public interface IAssessmentBusiness
    {
        AssessmentDetail CreateNewAssessment(int currentUserId, string workflow);
        AssessmentDetail CreateNewAssessmentForImport(int currentUserId);
        IEnumerable<usp_Assessments_For_UserResult> GetAssessmentsForUser(int userId);
        AnalyticsAssessment GetAnalyticsAssessmentDetail(int assessmentId);
        AssessmentDetail GetAssessmentDetail(int assessmentId, string token = "");
        void GetMaturityModelDetails(ref AssessmentDetail assessment);
        void GetSelectedStandards(ref AssessmentDetail assessment);
        void DetermineFeaturesFromData(ref AssessmentDetail assessment);
        int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment);
        void CreateIrpHeaders(int assessmentId);
        List<DEMOGRAPHICS_ORGANIZATION_TYPE> GetOrganizationTypes();
        bool IsCurrentUserOnAssessment(int assessmentId);
        ASSESSMENTS GetAssessmentById(int assessmentId);
        DateTime GetLastModifiedDateUtc(int assessmentId);
        IEnumerable<usp_Assessments_Completion_For_UserResult> GetAssessmentsCompletionForUser(int userId);
    }
}
