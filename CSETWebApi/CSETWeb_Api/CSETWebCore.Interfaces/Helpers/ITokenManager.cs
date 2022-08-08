using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface ITokenManager
    {
        Task SetToken(String tokenString);
        Task Init(string tokenString);
        string Payload(string claim);
        int? PayloadInt(string claim);
        Task<string> GenerateToken(int userId, string tzOffset, int expSeconds, int? assessmentId, int? aggregationId,
            string scope);
        Task<bool> IsTokenValid(string tokenString);
        string ReadTokenPayload(JwtSecurityToken token, string claim);
        Task AuthorizeUserForAssessment(int assessmentId);
        void ValidateTokenForAssessment(int assessmentId);
        int GetCurrentUserId();
        Task GenerateSecret();
        Task<string> GetSecret();
        int GetUserId();
        Task<int> AssessmentForUser();
        Task<int> AssessmentForUser(string tokenString);
        Task<int> AssessmentForUser(int userId, int? assessmentId);
        Task AuthorizeAdminRole();
        Task<bool> AmILastAdminWithUsers(int assessmentId);
        void Throw401();
        bool IsAuthenticated();
    }
}
