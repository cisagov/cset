////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Moq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Interfaces;
using CSETWebCore.Business.Question;

namespace CSETWebCore.Business.Tests.Assessment.Fixtures
{
    /// <summary>
    /// Shared test fixture providing common mocks for Assessment-related tests.
    /// Implements IDisposable to work with xUnit's IClassFixture pattern.
    /// </summary>
    public class AssessmentTestsFixture : IDisposable
    {
        // DbContext Mocks
        public Mock<CSETContext> CsetContextMock { get; } = new();
        public Mock<CsetwebContext> CsetwebContextMock { get; } = new();

        // Interface Mocks
        public Mock<ITokenManager> TokenManagerMock { get; } = new();
        public Mock<IUtilities> UtilitiesMock { get; } = new();
        public Mock<IContactBusiness> ContactBusinessMock { get; } = new();
        public Mock<ISalBusiness> SalBusinessMock { get; } = new();
        public Mock<IMaturityBusiness> MaturityBusinessMock { get; } = new();
        public Mock<IAssessmentUtil> AssessmentUtilMock { get; } = new();
        public Mock<IStandardsBusiness> StandardsBusinessMock { get; } = new();
        public Mock<IDiagramManager> DiagramManagerMock { get; } = new();
        public Mock<IHttpContextAccessor> HttpContextAccessorMock { get; } = new();
        public Mock<Hooks> HooksMock { get; } = new();

        // HTTP Context
        public DefaultHttpContext HttpContext { get; } = new();

        public AssessmentTestsFixture()
        {
            SetupDefaultMocks();
        }

        private void SetupDefaultMocks()
        {
            // Setup Token/User defaults
            var userId = 42;
            var assessmentId = 1;

            TokenManagerMock.Setup(t => t.GetUserId()).Returns(userId);
            TokenManagerMock.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            TokenManagerMock.Setup(t => t.GetCurrentLanguage()).Returns("en");
            TokenManagerMock.Setup(t => t.GetAccessKey()).Returns((string)null!);
            TokenManagerMock.Setup(t => t.Payload(It.IsAny<string>())).Returns("");

            // Setup HTTP Context with claims
            HttpContext.User = new ClaimsPrincipal(new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, userId.ToString()),
                new Claim(ClaimTypes.Name, "unit.tester")
            }, "TestAuth"));
            HttpContextAccessorMock.Setup(a => a.HttpContext).Returns(HttpContext);

            // Setup Utilities mock
            UtilitiesMock.Setup(u => u.UtcToLocal(It.IsAny<DateTime>()))
                .Returns<DateTime>(dt => dt); // Pass-through for simplicity

            // Setup default SaveChanges behavior
            CsetContextMock.Setup(c => c.SaveChanges()).Returns(1);
            CsetwebContextMock.Setup(c => c.SaveChanges()).Returns(1);

            // Setup default collaborator behaviors (can be overridden in tests)
            SalBusinessMock.Setup(s => s.SetDefaultSal(It.IsAny<int>(), It.IsAny<string>())).Verifiable();
            MaturityBusinessMock.Setup(m => m.PersistSelectedMaturityModel(It.IsAny<int>(), It.IsAny<string>())).Verifiable();
            MaturityBusinessMock.Setup(m => m.ClearMaturityModel(It.IsAny<int>())).Verifiable();
            StandardsBusinessMock.Setup(s => s.PersistSelectedStandards(It.IsAny<int>(), It.IsAny<List<string>>())).Verifiable();
            AssessmentUtilMock.Setup(a => a.TouchAssessment(It.IsAny<int>())).Verifiable();
            ContactBusinessMock.Setup(c => c.AddContactToAssessment(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<bool>())).Verifiable();
        }

        public void Dispose()
        {
            // Cleanup if needed
        }
    }
}
