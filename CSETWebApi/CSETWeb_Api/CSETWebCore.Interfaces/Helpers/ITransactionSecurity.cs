using System.IdentityModel.Tokens.Jwt;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface ITransactionSecurity
    {
        string GenerateToken(int userId, string tzOffset, int expSeconds, int? assessmentId, int? aggregationId,
            string scope);

        bool IsTokenValid(string tokenString);
        string ReadTokenPayload(JwtSecurityToken token, string claim);
        void AuthorizeUserForAssessment(int assessmentId);
        void ValidateTokenForAssessment(int assessmentId);
        int GetCurrentUserId();
        int GetAssessmentId();
        void GenerateSecret();
        string GetSecret();
    }
}