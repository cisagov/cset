using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Api.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Business.Findings;
using CSETWebCore.Interfaces.Helpers;
using System.IdentityModel.Tokens.Jwt;
using CSETWebCore.DataLayer.Model;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Api.Controllers.Tests
{
    [TestClass()]
    public class QuestionsControllerTests
    {
        private CSETContext context;

        [TestInitialize()]
        public void Initialize()
        {
            var builder = new ConfigurationBuilder()
               .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            var configuration = builder.Build();

            var optionsBuilder = new DbContextOptionsBuilder<CSETContext>();
            optionsBuilder.UseSqlServer(configuration.GetConnectionString("CSET_DB"));
            this.context = new CSETContext(configuration);

        }

        [TestMethod()]
        public void SaveOverrideIssueTextTest()
        {
            
            var assessment_id = context.ASSESSMENTS.FirstOrDefault();
            Assert.IsNotNull(assessment_id);

            var tokenmanager = new TestToken()
            {
                Assessment_id = assessment_id.Assessment_Id
            };


            QuestionsController questionsController = new QuestionsController(tokenmanager,null,null,null,null,null,null,null,null
                ,context);

            
            List<ActionItemText> list = new List<ActionItemText>();
            list.Add(new ActionItemText()
            {
                Mat_Question_Id = 7569,
                ActionItemOverrideText = 7569 + "This is override Text"
            });
            var tmp = new ActionItemTextUpdate()
            {
                actionTextItems = list,
                finding_Id = 132
            };
            questionsController.SaveOverrideIssueText(tmp);

        }
    }

    public class TestToken : ITokenManager
    {
        public int Assessment_id { get; internal set; }

        public bool AmILastAdminWithUsers(int assessmentId)
        {
            throw new NotImplementedException();
        }

        public int AssessmentForUser()
        {
            return this.Assessment_id;
        }

        public int AssessmentForUser(string tokenString)
        {
            throw new NotImplementedException();
        }

        public int AssessmentForUser(int userId, int? assessmentId)
        {
            return this.Assessment_id;
        }

        public void AuthorizeAdminRole()
        {
            throw new NotImplementedException();
        }

        public void AuthorizeUserForAssessment(int assessmentId)
        {
            throw new NotImplementedException();
        }

        public void GenerateSecret()
        {
            throw new NotImplementedException();
        }

        public string GenerateToken(int userId, string tzOffset, int expSeconds, int? assessmentId, int? aggregationId, string scope)
        {
            throw new NotImplementedException();
        }

        public int GetCurrentUserId()
        {
            throw new NotImplementedException();
        }

        public string GetSecret()
        {
            throw new NotImplementedException();
        }

        public int GetUserId()
        {
            throw new NotImplementedException();
        }

        public void Init(string tokenString)
        {
            throw new NotImplementedException();
        }

        public bool IsAuthenticated()
        {
            throw new NotImplementedException();
        }

        public bool IsTokenValid(string tokenString)
        {
            throw new NotImplementedException();
        }

        public string Payload(string claim)
        {
            throw new NotImplementedException();
        }

        public int? PayloadInt(string claim)
        {
            throw new NotImplementedException();
        }

        public string ReadTokenPayload(JwtSecurityToken token, string claim)
        {
            throw new NotImplementedException();
        }

        public void SetToken(string tokenString)
        {
            throw new NotImplementedException();
        }

        public void Throw401()
        {
            throw new NotImplementedException();
        }

        public void ValidateTokenForAssessment(int assessmentId)
        {
            throw new NotImplementedException();
        }
    }
}