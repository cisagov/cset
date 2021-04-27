
using System.Collections.Generic;
using CSETWebCore.Model.Assessment;
using DataLayerCore.Model;

namespace CSETWebCore.Interfaces.Assessment
{
    public interface IAssessmentBusiness
    {
        AssessmentDetail CreateNewAssessment(int currentUserId, bool mode);
        AssessmentDetail CreateNewAssessmentForImport(int currentUserId);
        IEnumerable<Assessments_For_User> GetAssessmentsForUser(int userId);
        AnalyticsAssessment GetAnalyticsAssessmentDetail(int assessmentId);
        AssessmentDetail GetAssessmentDetail(int assessmentId);
        void GetMaturityDetails(ref AssessmentDetail assessment, CSET_Context db);
        void GetSelectedStandards(ref AssessmentDetail assessment, CSET_Context db);
        void DetermineFeaturesFromData(ref AssessmentDetail assessment, CSET_Context db);
        int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment);
        void CreateIrpHeaders(int assessmentId);
        Demographics GetDemographics(int assessmentId);
        List<DEMOGRAPHICS_ORGANIZATION_TYPE> GetOrganizationTypes();
        int SaveDemographics(Demographics demographics);
        bool IsCurrentUserOnAssessment(int assessmentId);
        ASSESSMENTS GetAssessmentById(int assessmentId);
    }
}
