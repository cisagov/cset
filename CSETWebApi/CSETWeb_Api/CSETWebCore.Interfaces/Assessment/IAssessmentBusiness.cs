
using System.Collections.Generic;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Assessment
{
    public interface IAssessmentBusiness
    {
        AssessmentDetail CreateNewAssessment(int currentUserId, bool mode);
        AssessmentDetail CreateNewAssessmentForImport(int currentUserId);
        IEnumerable<Assessments_For_User> GetAssessmentsForUser(int userId);
        AnalyticsAssessment GetAnalyticsAssessmentDetail(int assessmentId);
        AssessmentDetail GetAssessmentDetail(int assessmentId);
        void GetMaturityModelDetails(ref AssessmentDetail assessment);
        void GetSelectedStandards(ref AssessmentDetail assessment);
        void DetermineFeaturesFromData(ref AssessmentDetail assessment);
        int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment);
        void CreateIrpHeaders(int assessmentId);
        Demographics GetDemographics(int assessmentId);
        List<DEMOGRAPHICS_ORGANIZATION_TYPE> GetOrganizationTypes();
        int SaveDemographics(Demographics demographics);
        bool IsCurrentUserOnAssessment(int assessmentId);
        ASSESSMENTS GetAssessmentById(int assessmentId);
    }
}
