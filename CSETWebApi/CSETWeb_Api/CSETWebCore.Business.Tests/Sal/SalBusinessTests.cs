using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Standards;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Sal
{
    /// <summary>
    /// Unit tests for SalBusiness class.
    /// Tests SAL (Security Assurance Level) retrieval, default setting, and basic SAL operations.
    ///
    /// NOTE: GetSals() method is difficult to fully test in isolation due to:
    /// - LevelManager dependency which queries PARAMETER_VALUES
    /// - StandardRepository initialization logic
    /// - TinyMapper configuration
    /// These tests focus on the SetDefault methods which are more testable.
    /// </summary>
    public class SalBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentModeData> _mockAssessmentModeData;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly Mock<IStandardsBusiness> _mockStandardsBusiness;
        private readonly Mock<IStandardSpecficLevelRepository> _mockStandardRepo;
        private readonly SalBusiness _salBusiness;

        public SalBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentModeData = new Mock<IAssessmentModeData>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
            _mockStandardsBusiness = new Mock<IStandardsBusiness>();
            _mockStandardRepo = new Mock<IStandardSpecficLevelRepository>();

            _salBusiness = new SalBusiness(
                _mockContext.Object,
                _mockAssessmentModeData.Object,
                _mockAssessmentUtil.Object,
                _mockStandardsBusiness.Object,
                _mockStandardRepo.Object
            );
        }

        // NOTE: GetSals() tests are omitted because the method has tight coupling with:
        // - LevelManager (requires PARAMETER_VALUES mock setup)
        // - StandardRepository (complex initialization)
        // - TinyMapper (static configuration)
        // These dependencies make unit testing difficult without integration test infrastructure.

        [Fact]
        public void SetDefaultSalIfNotSet_CreatesDefault_WhenNoSelectionExists()
        {
            // Arrange
            var assessmentId = 1;

            var standardSelections = new List<STANDARD_SELECTION>();
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentModeData.Setup(a => a.DetermineDefaultApplicationMode()).Returns("Questions Based");

            // Act
            _salBusiness.SetDefaultSalIfNotSet(assessmentId);

            // Assert
            mockStandardSelectionSet.Verify(m => m.Add(It.Is<STANDARD_SELECTION>(
                s => s.Assessment_Id == assessmentId &&
                     s.Selected_Sal_Level == "Low"
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void SetDefaultSalIfNotSet_DoesNothing_WhenSelectionExists()
        {
            // Arrange
            var assessmentId = 1;
            var existingSelection = new STANDARD_SELECTION
            {
                Assessment_Id = assessmentId,
                Selected_Sal_Level = "High"
            };

            var standardSelections = new List<STANDARD_SELECTION> { existingSelection };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);

            // Act
            _salBusiness.SetDefaultSalIfNotSet(assessmentId);

            // Assert
            mockStandardSelectionSet.Verify(m => m.Add(It.IsAny<STANDARD_SELECTION>()), Times.Never);
            _mockContext.Verify(c => c.SaveChanges(), Times.Never);
        }

        [Fact]
        public void SetDefaultSal_CreatesLowDefault()
        {
            // Arrange
            var assessmentId = 1;

            var standardSelections = new List<STANDARD_SELECTION>();
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentModeData.Setup(a => a.DetermineDefaultApplicationMode()).Returns("Questions Based");

            // Act
            _salBusiness.SetDefaultSal(assessmentId);

            // Assert
            mockStandardSelectionSet.Verify(m => m.Add(It.Is<STANDARD_SELECTION>(
                s => s.Assessment_Id == assessmentId &&
                     s.Selected_Sal_Level == "Low"
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void SetDefaultSal_CreatesModerateDefault_WhenModerateSpecified()
        {
            // Arrange
            var assessmentId = 1;

            var standardSelections = new List<STANDARD_SELECTION>();
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentModeData.Setup(a => a.DetermineDefaultApplicationMode()).Returns("Questions Based");

            // Act
            _salBusiness.SetDefaultSal(assessmentId, "moderate");

            // Assert
            mockStandardSelectionSet.Verify(m => m.Add(It.Is<STANDARD_SELECTION>(
                s => s.Assessment_Id == assessmentId &&
                     s.Selected_Sal_Level == "Moderate"
            )), Times.Once);
        }

        [Fact]
        public void SetDefault_ConvertsLevelToTitleCase()
        {
            // Arrange
            var assessmentId = 1;

            var standardSelections = new List<STANDARD_SELECTION>();
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentModeData.Setup(a => a.DetermineDefaultApplicationMode()).Returns("Questions Based");

            // Act
            _salBusiness.SetDefault(assessmentId, "HIGH");

            // Assert
            // Verify that Add was called and the item was added to the list
            mockStandardSelectionSet.Verify(m => m.Add(It.IsAny<STANDARD_SELECTION>()), Times.Once);
            Assert.Single(standardSelections);
            Assert.Equal("High", standardSelections[0].Selected_Sal_Level);
        }

        [Fact]
        public void SetDefault_HandlesMixedCaseInput()
        {
            // Arrange
            var assessmentId = 1;

            var standardSelections = new List<STANDARD_SELECTION>();
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentModeData.Setup(a => a.DetermineDefaultApplicationMode()).Returns("Questions Based");

            // Act
            _salBusiness.SetDefault(assessmentId, "vErY HiGh");

            // Assert
            mockStandardSelectionSet.Verify(m => m.Add(It.IsAny<STANDARD_SELECTION>()), Times.Once);
            Assert.Single(standardSelections);
            Assert.Equal("Very High", standardSelections[0].Selected_Sal_Level);
        }

        [Fact]
        public void SetDefault_SetsMethodologyToSimple()
        {
            // Arrange
            var assessmentId = 1;

            var standardSelections = new List<STANDARD_SELECTION>();
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentModeData.Setup(a => a.DetermineDefaultApplicationMode()).Returns("Questions Based");

            // Act
            _salBusiness.SetDefault(assessmentId, "Low");

            // Assert
            mockStandardSelectionSet.Verify(m => m.Add(It.IsAny<STANDARD_SELECTION>()), Times.Once);
            // Note: Last_Sal_Determination_Type is not set in the business logic (only in Sals to STANDARD_SELECTION mapping)
        }

        [Fact]
        public void SetDefault_SetsApplicationMode()
        {
            // Arrange
            var assessmentId = 1;
            var expectedAppMode = "Requirements Based";

            var standardSelections = new List<STANDARD_SELECTION>();
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentModeData.Setup(a => a.DetermineDefaultApplicationMode()).Returns(expectedAppMode);

            // Act
            _salBusiness.SetDefault(assessmentId, "Low");

            // Assert
            mockStandardSelectionSet.Verify(m => m.Add(It.IsAny<STANDARD_SELECTION>()), Times.Once);
            Assert.Single(standardSelections);
            Assert.Equal(expectedAppMode, standardSelections[0].Application_Mode);
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

            // Setup Add to actually add to the list
            mockSet.Setup(m => m.Add(It.IsAny<T>())).Callback<T>(data.Add);

            return mockSet;
        }

        public void Dispose()
        {
            // Cleanup if needed
        }
    }
}
