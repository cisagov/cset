////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Sal
{
    /// <summary>
    /// Unit tests for NistSpecialFactor class.
    /// Tests loading and saving of CNSS CIA (Confidentiality, Integrity, Availability) justifications.
    ///
    /// NOTE: NistSpecialFactor has tight coupling with NistProcessingLogic for SAL level mapping.
    /// These tests focus on data persistence and retrieval logic.
    /// </summary>
    public class NistSpecialFactorTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;

        public NistSpecialFactorTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
        }

        [Fact]
        public void LoadFromDb_LoadsAvailabilityData_WhenExists()
        {
            // Arrange
            var assessmentId = 1;
            var specialFactor = new NistSpecialFactor();

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>
            {
                new CNSS_CIA_JUSTIFICATIONS
                {
                    Assessment_Id = assessmentId,
                    CIA_Type = "Availability",
                    Justification = "High availability required",
                    DropDownValueLevel = "High"
                }
            };

            var mockCiaSet = CreateMockDbSet(ciaJustifications);
            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);

            // Act
            specialFactor.LoadFromDb(assessmentId, _mockContext.Object);

            // Assert
            Assert.Equal("High availability required", specialFactor.Availability_Special_Factor);
            Assert.NotNull(specialFactor.Availability_Value);
            Assert.Equal(3, specialFactor.Availability_Value.SALValue);
            Assert.Equal("High", specialFactor.Availability_Value.SALName);
        }

        [Fact]
        public void LoadFromDb_LoadsConfidentialityData_WhenExists()
        {
            // Arrange
            var assessmentId = 1;
            var specialFactor = new NistSpecialFactor();

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>
            {
                new CNSS_CIA_JUSTIFICATIONS
                {
                    Assessment_Id = assessmentId,
                    CIA_Type = "Confidentiality",
                    Justification = "Moderate confidentiality needed",
                    DropDownValueLevel = "Moderate"
                }
            };

            var mockCiaSet = CreateMockDbSet(ciaJustifications);
            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);

            // Act
            specialFactor.LoadFromDb(assessmentId, _mockContext.Object);

            // Assert
            Assert.Equal("Moderate confidentiality needed", specialFactor.Confidentiality_Special_Factor);
            Assert.NotNull(specialFactor.Confidentiality_Value);
            Assert.Equal(2, specialFactor.Confidentiality_Value.SALValue);
            Assert.Equal("Moderate", specialFactor.Confidentiality_Value.SALName);
        }

        [Fact]
        public void LoadFromDb_LoadsIntegrityData_WhenExists()
        {
            // Arrange
            var assessmentId = 1;
            var specialFactor = new NistSpecialFactor();

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>
            {
                new CNSS_CIA_JUSTIFICATIONS
                {
                    Assessment_Id = assessmentId,
                    CIA_Type = "Integrity",
                    Justification = "Low integrity acceptable",
                    DropDownValueLevel = "Low"
                }
            };

            var mockCiaSet = CreateMockDbSet(ciaJustifications);
            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);

            // Act
            specialFactor.LoadFromDb(assessmentId, _mockContext.Object);

            // Assert
            Assert.Equal("Low integrity acceptable", specialFactor.Integrity_Special_Factor);
            Assert.NotNull(specialFactor.Integrity_Value);
            Assert.Equal(1, specialFactor.Integrity_Value.SALValue);
            Assert.Equal("Low", specialFactor.Integrity_Value.SALName);
        }

        [Fact]
        public void LoadFromDb_LoadsAllThreeTypes()
        {
            // Arrange
            var assessmentId = 1;
            var specialFactor = new NistSpecialFactor();

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>
            {
                new CNSS_CIA_JUSTIFICATIONS
                {
                    Assessment_Id = assessmentId,
                    CIA_Type = "Availability",
                    Justification = "Availability justification",
                    DropDownValueLevel = "High"
                },
                new CNSS_CIA_JUSTIFICATIONS
                {
                    Assessment_Id = assessmentId,
                    CIA_Type = "Confidentiality",
                    Justification = "Confidentiality justification",
                    DropDownValueLevel = "Moderate"
                },
                new CNSS_CIA_JUSTIFICATIONS
                {
                    Assessment_Id = assessmentId,
                    CIA_Type = "Integrity",
                    Justification = "Integrity justification",
                    DropDownValueLevel = "Low"
                }
            };

            var mockCiaSet = CreateMockDbSet(ciaJustifications);
            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);

            // Act
            specialFactor.LoadFromDb(assessmentId, _mockContext.Object);

            // Assert
            Assert.Equal("Availability justification", specialFactor.Availability_Special_Factor);
            Assert.Equal("Confidentiality justification", specialFactor.Confidentiality_Special_Factor);
            Assert.Equal("Integrity justification", specialFactor.Integrity_Special_Factor);
            Assert.Equal("High", specialFactor.Availability_Value.SALName);
            Assert.Equal("Moderate", specialFactor.Confidentiality_Value.SALName);
            Assert.Equal("Low", specialFactor.Integrity_Value.SALName);
        }

        [Fact]
        public void LoadFromDb_IsCaseInsensitive_ForCIAType()
        {
            // Arrange
            var assessmentId = 1;
            var specialFactor = new NistSpecialFactor();

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>
            {
                new CNSS_CIA_JUSTIFICATIONS
                {
                    Assessment_Id = assessmentId,
                    CIA_Type = "AVAILABILITY",
                    Justification = "Test",
                    DropDownValueLevel = "High"
                }
            };

            var mockCiaSet = CreateMockDbSet(ciaJustifications);
            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);

            // Act
            specialFactor.LoadFromDb(assessmentId, _mockContext.Object);

            // Assert
            Assert.Equal("Test", specialFactor.Availability_Special_Factor);
        }

        [Fact]
        public void SaveToDb_CreatesNewRecord_WhenNotExists()
        {
            // Arrange
            var assessmentId = 1;
            var specialFactor = new NistSpecialFactor
            {
                Availability_Special_Factor = "New availability justification",
                Availability_Value = new SALLevelNIST { SALValue = 2, SALName = "Moderate" },
                Confidentiality_Special_Factor = "New confidentiality justification",
                Confidentiality_Value = new SALLevelNIST { SALValue = 3, SALName = "High" },
                Integrity_Special_Factor = "New integrity justification",
                Integrity_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" }
            };

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>();
            var mockCiaSet = CreateMockDbSet(ciaJustifications);

            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            specialFactor.SaveToDb(assessmentId, _mockContext.Object, _mockAssessmentUtil.Object);

            // Assert
            mockCiaSet.Verify(m => m.Add(It.Is<CNSS_CIA_JUSTIFICATIONS>(
                c => c.Assessment_Id == assessmentId && c.CIA_Type == "Availability"
            )), Times.Once);
            mockCiaSet.Verify(m => m.Add(It.Is<CNSS_CIA_JUSTIFICATIONS>(
                c => c.Assessment_Id == assessmentId && c.CIA_Type == "Confidentiality"
            )), Times.Once);
            mockCiaSet.Verify(m => m.Add(It.Is<CNSS_CIA_JUSTIFICATIONS>(
                c => c.Assessment_Id == assessmentId && c.CIA_Type == "Integrity"
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void SaveToDb_UpdatesExistingRecord_WhenExists()
        {
            // Arrange
            var assessmentId = 1;
            var existingRecord = new CNSS_CIA_JUSTIFICATIONS
            {
                Assessment_Id = assessmentId,
                CIA_Type = "Availability",
                Justification = "Old justification",
                DropDownValueLevel = "Low"
            };

            var specialFactor = new NistSpecialFactor
            {
                Availability_Special_Factor = "Updated justification",
                Availability_Value = new SALLevelNIST { SALValue = 3, SALName = "High" },
                Confidentiality_Special_Factor = "",
                Confidentiality_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" },
                Integrity_Special_Factor = "",
                Integrity_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" }
            };

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS> { existingRecord };
            var mockCiaSet = CreateMockDbSet(ciaJustifications);

            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            specialFactor.SaveToDb(assessmentId, _mockContext.Object, _mockAssessmentUtil.Object);

            // Assert
            Assert.Equal("Updated justification", existingRecord.Justification);
            Assert.Equal("High", existingRecord.DropDownValueLevel);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void SaveToDb_HandlesNullJustification()
        {
            // Arrange
            var assessmentId = 1;
            var specialFactor = new NistSpecialFactor
            {
                Availability_Special_Factor = null,
                Availability_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" },
                Confidentiality_Special_Factor = null,
                Confidentiality_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" },
                Integrity_Special_Factor = null,
                Integrity_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" }
            };

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>();
            var mockCiaSet = CreateMockDbSet(ciaJustifications);

            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            specialFactor.SaveToDb(assessmentId, _mockContext.Object, _mockAssessmentUtil.Object);

            // Assert
            mockCiaSet.Verify(m => m.Add(It.Is<CNSS_CIA_JUSTIFICATIONS>(
                c => c.Justification == string.Empty
            )), Times.Exactly(3));
        }

        [Fact]
        public void SaveToDb_CapitalizesFirstLetterOfCIAType()
        {
            // Arrange
            var assessmentId = 1;
            var specialFactor = new NistSpecialFactor
            {
                Availability_Special_Factor = "Test",
                Availability_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" },
                Confidentiality_Special_Factor = "Test",
                Confidentiality_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" },
                Integrity_Special_Factor = "Test",
                Integrity_Value = new SALLevelNIST { SALValue = 1, SALName = "Low" }
            };

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>();
            var mockCiaSet = CreateMockDbSet(ciaJustifications);

            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            specialFactor.SaveToDb(assessmentId, _mockContext.Object, _mockAssessmentUtil.Object);

            // Assert
            mockCiaSet.Verify(m => m.Add(It.Is<CNSS_CIA_JUSTIFICATIONS>(
                c => c.CIA_Type == "Availability"
            )), Times.Once);
            mockCiaSet.Verify(m => m.Add(It.Is<CNSS_CIA_JUSTIFICATIONS>(
                c => c.CIA_Type == "Confidentiality"
            )), Times.Once);
            mockCiaSet.Verify(m => m.Add(It.Is<CNSS_CIA_JUSTIFICATIONS>(
                c => c.CIA_Type == "Integrity"
            )), Times.Once);
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
