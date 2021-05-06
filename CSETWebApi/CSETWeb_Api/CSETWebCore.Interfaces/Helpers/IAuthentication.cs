namespace CSETWebCore.Interfaces.Helpers
{
    public interface IAuthentication
    {
        int GetUserId();
        int AssessmentForUser();
        int AssessmentForUser(string tokenString);
        int AssessmentForUser(int userId, int? assessmentId);
        void AuthorizeAdminRole();
        bool AmILastAdminWithUsers(int assessmentId);
        void Throw401();
        bool IsAuthenticated();
    }
}
