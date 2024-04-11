//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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
        void SetToken(String tokenString);
        void Init(string tokenString);
        string Payload(string claim);
        int? PayloadInt(string claim);
        string GenerateToken(int? userId, string accessKey, string tzOffset, int expSeconds, int? assessmentId, int? aggregationId,
            string scope);
        bool IsTokenValid(string tokenString);
        string ReadTokenPayload(JwtSecurityToken token, string claim);
        void AuthorizeUserForAssessment(int assessmentId);
        void ValidateTokenForAssessment(int assessmentId);
        int? GetCurrentUserId();
        string GetCurrentLanguage();
        void GenerateSecret();
        string GetSecret();
        int? GetUserId();
        string GetAccessKey();
        int AssessmentForUser();
        int AssessmentForUser(string tokenString);
        int AssessmentForUser(int? userId, string accessKey, int? assessmentId);
        void AuthorizeAdminRole();
        bool AmILastAdminWithUsers(int assessmentId);
        void Throw401();
        bool IsAuthenticated();
    }
}
