using CSETWebCore.Business.Contact;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Conversion
{
    /// <summary>
    /// Unit tests for ConversionBusiness class.
    /// Tests Cyber Florida assessment conversion functionality.
    /// </summary>
    public class ConversionBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly ConversionBusiness _conversionBusiness;

        public ConversionBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();

            _conversionBusiness = new ConversionBusiness(
                _mockContext.Object,
                _mockAssessmentUtil.Object
            );
        }

        [Fact]
        public void IsEntryCF_ReturnsTrue_WhenMaturitySubmodelIsRRACF()
        {
            // Arrange
            var assessmentId = 1;
            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = "MATURITY-SUBMODEL",
                    StringValue = "RRA CF"
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            var mockAvailStandardsSet = CreateMockDbSet(new List<AVAILABLE_STANDARDS>());

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);

            // Act
            var result = _conversionBusiness.IsEntryCF(assessmentId);

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsEntryCF_ReturnsTrue_WhenFloridaCSFV2IsSelected()
        {
            // Arrange
            var assessmentId = 1;
            var standards = new List<AVAILABLE_STANDARDS>
            {
                new AVAILABLE_STANDARDS
                {
                    Assessment_Id = assessmentId,
                    Set_Name = "Florida_NCSF_V2",
                    Selected = true
                }
            };

            var mockDemographicsSet = CreateMockDbSet(new List<DETAILS_DEMOGRAPHICS>());
            var mockAvailStandardsSet = CreateMockDbSet(standards);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);

            // Act
            var result = _conversionBusiness.IsEntryCF(assessmentId);

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsEntryCF_ReturnsTrue_WhenFloridaCSFV1IsSelected()
        {
            // Arrange
            var assessmentId = 1;
            var standards = new List<AVAILABLE_STANDARDS>
            {
                new AVAILABLE_STANDARDS
                {
                    Assessment_Id = assessmentId,
                    Set_Name = "Florida_NCSF_V1",
                    Selected = true
                }
            };

            var mockDemographicsSet = CreateMockDbSet(new List<DETAILS_DEMOGRAPHICS>());
            var mockAvailStandardsSet = CreateMockDbSet(standards);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);

            // Act
            var result = _conversionBusiness.IsEntryCF(assessmentId);

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsEntryCF_ReturnsFalse_WhenNeitherConditionIsMet()
        {
            // Arrange
            var assessmentId = 1;
            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = "MATURITY-SUBMODEL",
                    StringValue = "OTHER"
                }
            };

            var standards = new List<AVAILABLE_STANDARDS>
            {
                new AVAILABLE_STANDARDS
                {
                    Assessment_Id = assessmentId,
                    Set_Name = "NIST",
                    Selected = true
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            var mockAvailStandardsSet = CreateMockDbSet(standards);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);

            // Act
            var result = _conversionBusiness.IsEntryCF(assessmentId);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsEntryCF_ReturnsFalse_WhenNoDataExists()
        {
            // Arrange
            var assessmentId = 1;
            var mockDemographicsSet = CreateMockDbSet(new List<DETAILS_DEMOGRAPHICS>());
            var mockAvailStandardsSet = CreateMockDbSet(new List<AVAILABLE_STANDARDS>());

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);

            // Act
            var result = _conversionBusiness.IsEntryCF(assessmentId);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsEntryCF_WithListOfIds_ReturnsCorrectResults()
        {
            // Arrange
            var assessmentIds = new List<int> { 1, 2, 3 };

            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = 1,
                    DataItemName = "MATURITY-SUBMODEL",
                    StringValue = "RRA CF"
                }
            };

            var standards = new List<AVAILABLE_STANDARDS>
            {
                new AVAILABLE_STANDARDS
                {
                    Assessment_Id = 2,
                    Set_Name = "Florida_NCSF_V2",
                    Selected = true
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            var mockAvailStandardsSet = CreateMockDbSet(standards);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);

            // Act
            var result = _conversionBusiness.IsEntryCF(assessmentIds);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(3, result.Count);
            Assert.True(result.First(x => x.AssessmentId == 1).IsEntry);
            Assert.True(result.First(x => x.AssessmentId == 2).IsEntry);
            Assert.False(result.First(x => x.AssessmentId == 3).IsEntry);
        }

        [Fact]
        public void ConvertCF_RemovesMaturitySubmodelRecord()
        {
            // Arrange
            var assessmentId = 1;
            var cfRraRecord = new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = assessmentId,
                DataItemName = "MATURITY-SUBMODEL",
                StringValue = "RRA CF"
            };

            var demographics = new List<DETAILS_DEMOGRAPHICS> { cfRraRecord };
            var mockDemographicsSet = CreateMockDbSet(demographics);

            var standards = new List<AVAILABLE_STANDARDS>();
            var mockAvailStandardsSet = CreateMockDbSet(standards);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            _conversionBusiness.ConvertCF(assessmentId);

            // Assert
            mockDemographicsSet.Verify(m => m.Remove(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.DataItemName == "MATURITY-SUBMODEL" && d.StringValue == "RRA CF")), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void ConvertCF_SwapsStandardFromFloridaCSFToFullCSF()
        {
            // Arrange
            var assessmentId = 1;
            var floridaStandard = new AVAILABLE_STANDARDS
            {
                Assessment_Id = assessmentId,
                Set_Name = "Florida_NCSF_V2",
                Selected = true
            };

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);

            var standards = new List<AVAILABLE_STANDARDS> { floridaStandard };
            var mockAvailStandardsSet = CreateMockDbSet(standards);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            _conversionBusiness.ConvertCF(assessmentId);

            // Assert
            mockAvailStandardsSet.Verify(m => m.Remove(It.Is<AVAILABLE_STANDARDS>(
                s => s.Set_Name == "Florida_NCSF_V2")), Times.Once);
            mockAvailStandardsSet.Verify(m => m.Add(It.Is<AVAILABLE_STANDARDS>(
                s => s.Set_Name == "NCSF_V2" && s.Selected == true && s.Assessment_Id == assessmentId)), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
        }

        [Fact]
        public void ConvertCF_HandlesMissingMaturitySubmodelRecord()
        {
            // Arrange
            var assessmentId = 1;
            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);

            var standards = new List<AVAILABLE_STANDARDS>();
            var mockAvailStandardsSet = CreateMockDbSet(standards);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act & Assert - Should not throw
            _conversionBusiness.ConvertCF(assessmentId);

            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void ConvertCF_HandlesMissingStandardRecord()
        {
            // Arrange
            var assessmentId = 1;
            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);

            var standards = new List<AVAILABLE_STANDARDS>();
            var mockAvailStandardsSet = CreateMockDbSet(standards);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_STANDARDS).Returns(mockAvailStandardsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act & Assert - Should not throw
            _conversionBusiness.ConvertCF(assessmentId);

            mockAvailStandardsSet.Verify(m => m.Remove(It.IsAny<AVAILABLE_STANDARDS>()), Times.Never);
            mockAvailStandardsSet.Verify(m => m.Add(It.IsAny<AVAILABLE_STANDARDS>()), Times.Never);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
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
