
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Assessment
{
    public interface IAssessmentBusiness
    {
        Task<AssessmentDetail> CreateNewAssessment(int currentUserId, string workflow);
        Task<AssessmentDetail> CreateNewAssessmentForImport(int currentUserId);
        Task<IEnumerable<usp_Assessments_For_UserResult>> GetAssessmentsForUser(int userId);
        Task<AnalyticsAssessment> GetAnalyticsAssessmentDetail(int assessmentId);
        Task<AssessmentDetail> GetAssessmentDetail(int assessmentId, string token = "");
        Task<AssessmentDetail> GetMaturityModelDetails(AssessmentDetail assessment);
        Task<AssessmentDetail> GetSelectedStandards(AssessmentDetail assessment);
        Task<AssessmentDetail> DetermineFeaturesFromData(AssessmentDetail assessment);
        Task<int> SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment);
        Task CreateIrpHeaders(int assessmentId);
        Task<List<DEMOGRAPHICS_ORGANIZATION_TYPE>> GetOrganizationTypes();
        Task<bool> IsCurrentUserOnAssessment(int assessmentId);
        Task<ASSESSMENTS> GetAssessmentById(int assessmentId);
        Task<DateTime> GetLastModifiedDateUtc(int assessmentId);
        Task<IEnumerable<usp_Assessments_Completion_For_UserResult>> GetAssessmentsCompletionForUser(int userId);
        Task<List<ASSESSMENT_ICONS>> GetAllAssessmentIcons();
    }
}
