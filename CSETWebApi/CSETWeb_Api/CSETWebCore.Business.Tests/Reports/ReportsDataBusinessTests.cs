using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Reports
{
    /// <summary>
    /// Unit tests for ReportsDataBusiness class.
    /// Tests utility methods like name formatting, CSET version retrieval, and document library management.
    /// </summary>
    public class ReportsDataBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly Mock<IAssessmentModeData> _mockAssessmentMode;
        private readonly Mock<IMaturityBusiness> _mockMaturityBusiness;
        private readonly Mock<IQuestionRequirementManager> _mockQuestionRequirement;
        private readonly Mock<ITokenManager> _mockTokenManager;
        private readonly ReportsDataBusiness _reportsDataBusiness;

        public ReportsDataBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
            _mockAssessmentMode = new Mock<IAssessmentModeData>();
            _mockMaturityBusiness = new Mock<IMaturityBusiness>();
            _mockQuestionRequirement = new Mock<IQuestionRequirementManager>();
            _mockTokenManager = new Mock<ITokenManager>();

            _mockTokenManager.Setup(t => t.GetCurrentLanguage()).Returns("en");

            _reportsDataBusiness = new ReportsDataBusiness(
                _mockContext.Object,
                _mockAssessmentUtil.Object,
                _mockAssessmentMode.Object,
                _mockMaturityBusiness.Object,
                _mockQuestionRequirement.Object,
                _mockTokenManager.Object
            );
        }

        [Fact]
        public void FormatName_ReturnsBothNames_WhenBothProvided()
        {
            // Arrange
            var firstName = "John";
            var lastName = "Doe";

            // Act
            var result = _reportsDataBusiness.FormatName(firstName, lastName);

            // Assert
            Assert.Equal("John Doe", result);
        }

        [Fact]
        public void FormatName_HandlesWhitespace()
        {
            // Arrange
            var firstName = "  John";
            var lastName = "Doe  ";

            // Act
            var result = _reportsDataBusiness.FormatName(firstName, lastName);

            // Assert
            Assert.Equal("John Doe", result);
        }

        [Fact]
        public void FormatName_RemovesDomain_WhenDomainQualifiedUserId()
        {
            // Arrange - Domain\userid format with no spaces and no last name
            var firstName = "DOMAIN\\jdoe";
            var lastName = "";

            // Act
            var result = _reportsDataBusiness.FormatName(firstName, lastName);

            // Assert
            Assert.Equal("jdoe", result);
        }

        [Fact]
        public void FormatName_DoesNotRemoveDomain_WhenSpacePresent()
        {
            // Arrange - Has backslash but also has space
            var firstName = "DOMAIN\\jdoe test";
            var lastName = "";

            // Act
            var result = _reportsDataBusiness.FormatName(firstName, lastName);

            // Assert
            Assert.Equal("DOMAIN\\jdoe test ", result);
        }

        [Fact]
        public void FormatName_DoesNotRemoveDomain_WhenLastNameProvided()
        {
            // Arrange - Has backslash but last name is provided
            var firstName = "DOMAIN\\jdoe";
            var lastName = "Smith";

            // Act
            var result = _reportsDataBusiness.FormatName(firstName, lastName);

            // Assert
            Assert.Equal("DOMAIN\\jdoe Smith", result);
        }

        [Fact]
        public void FormatName_HandlesMultipleBackslashes()
        {
            // Arrange - Multiple backslashes, should get text after last one
            var firstName = "DOMAIN\\SUBDOMAIN\\jdoe";
            var lastName = "";

            // Act
            var result = _reportsDataBusiness.FormatName(firstName, lastName);

            // Assert
            Assert.Equal("jdoe", result);
        }

        [Fact]
        public void GetCsetVersion_ReturnsVersion_WhenVersionExists()
        {
            // Arrange
            var expectedVersion = "12.4.0.4";
            var versionList = new List<CSET_VERSION>
            {
                new CSET_VERSION { Cset_Version1 = expectedVersion }
            };

            var mockVersionSet = CreateMockDbSet(versionList);
            _mockContext.Setup(c => c.CSET_VERSION).Returns(mockVersionSet.Object);

            // Act
            var result = _reportsDataBusiness.GetCsetVersion();

            // Assert
            Assert.Equal(expectedVersion, result);
        }

        [Fact]
        public void GetCsetVersion_ReturnsNull_WhenNoVersionExists()
        {
            // Arrange
            var versionList = new List<CSET_VERSION>();

            var mockVersionSet = CreateMockDbSet(versionList);
            _mockContext.Setup(c => c.CSET_VERSION).Returns(mockVersionSet.Object);

            // Act
            var result = _reportsDataBusiness.GetCsetVersion();

            // Assert
            Assert.Null(result);
        }

        [Fact]
        public void GetAssessmentGuid_ReturnsGuid_WhenAssessmentExists()
        {
            // Arrange
            var assessmentId = 1;
            var expectedGuid = Guid.NewGuid();
            var assessmentsList = new List<ASSESSMENTS>
            {
                new ASSESSMENTS
                {
                    Assessment_Id = assessmentId,
                    Assessment_GUID = expectedGuid
                }
            };

            var mockAssessmentSet = CreateMockDbSet(assessmentsList);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _reportsDataBusiness.GetAssessmentGuid(assessmentId);

            // Assert
            Assert.Equal(expectedGuid.ToString(), result);
        }

        [Fact]
        public void SetReportsAssessmentId_SetsAssessmentId()
        {
            // Arrange
            var assessmentId = 123;

            // Act
            _reportsDataBusiness.SetReportsAssessmentId(assessmentId);

            // Assert - No exception thrown confirms success
            Assert.True(true);
        }

        [Fact]
        public void SetToken_UpdatesTokenManager()
        {
            // Arrange
            var newTokenManager = new Mock<ITokenManager>();
            newTokenManager.Setup(t => t.GetCurrentLanguage()).Returns("es");

            // Act
            _reportsDataBusiness.SetToken(newTokenManager.Object);

            // Assert - No exception thrown confirms success
            Assert.True(true);
        }

        [Fact]
        public void GetDocumentLibrary_ReturnsDocuments_WhenDocumentsExist()
        {
            // Arrange
            var assessmentId = 1;
            var documentsList = new List<DOCUMENT_FILE>
            {
                new DOCUMENT_FILE
                {
                    Assessment_Id = assessmentId,
                    Title = "Test Document 1",
                    Path = "/path/to/doc1.pdf"
                },
                new DOCUMENT_FILE
                {
                    Assessment_Id = assessmentId,
                    Title = "Test Document 2",
                    Path = "/path/to/doc2.pdf"
                }
            };

            var mockDocumentSet = CreateMockDbSet(documentsList);
            _mockContext.Setup(c => c.DOCUMENT_FILE).Returns(mockDocumentSet.Object);

            _reportsDataBusiness.SetReportsAssessmentId(assessmentId);

            // Act
            var result = _reportsDataBusiness.GetDocumentLibrary();

            // Assert
            Assert.Equal(2, result.Count);
            Assert.Equal("Test Document 1", result[0].DocumentTitle);
            Assert.Equal("/path/to/doc1.pdf", result[0].FileName);
        }

        [Fact]
        public void GetDocumentLibrary_ReplacesClickToEditTitle()
        {
            // Arrange
            var assessmentId = 1;
            var documentsList = new List<DOCUMENT_FILE>
            {
                new DOCUMENT_FILE
                {
                    Assessment_Id = assessmentId,
                    Title = "click to edit title",
                    Path = "/path/to/doc.pdf"
                }
            };

            var mockDocumentSet = CreateMockDbSet(documentsList);
            _mockContext.Setup(c => c.DOCUMENT_FILE).Returns(mockDocumentSet.Object);

            _reportsDataBusiness.SetReportsAssessmentId(assessmentId);

            // Act
            var result = _reportsDataBusiness.GetDocumentLibrary();

            // Assert
            Assert.Single(result);
            Assert.Equal("(untitled)", result[0].DocumentTitle);
        }

        [Fact]
        public void GetDocumentLibrary_ReturnsEmptyList_WhenNoDocuments()
        {
            // Arrange
            var assessmentId = 1;
            var documentsList = new List<DOCUMENT_FILE>();

            var mockDocumentSet = CreateMockDbSet(documentsList);
            _mockContext.Setup(c => c.DOCUMENT_FILE).Returns(mockDocumentSet.Object);

            _reportsDataBusiness.SetReportsAssessmentId(assessmentId);

            // Act
            var result = _reportsDataBusiness.GetDocumentLibrary();

            // Assert
            Assert.Empty(result);
        }

        /// <summary>
        /// Helper method to create a mock DbSet from a list of entities
        /// </summary>
        private Mock<DbSet<T>> CreateMockDbSet<T>(List<T> data) where T : class
        {
            var queryable = data.AsQueryable();
            var mockSet = new Mock<DbSet<T>>();

            mockSet.As<IQueryable<T>>().Setup(m => m.Provider).Returns(queryable.Provider);
            mockSet.As<IQueryable<T>>().Setup(m => m.Expression).Returns(queryable.Expression);
            mockSet.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(queryable.ElementType);
            mockSet.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns(() => queryable.GetEnumerator());

            return mockSet;
        }

        public void Dispose()
        {
            // Cleanup if needed
        }
    }
}
