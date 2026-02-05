using CSETWebCore.Business.Demographic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Demographic
{
    /// <summary>
    /// Unit tests for DemographicBusiness class.
    /// Tests demographic data retrieval, saving, and DETAILS_DEMOGRAPHICS record management.
    /// </summary>
    public class DemographicBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly DemographicBusiness _demographicBusiness;

        public DemographicBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
            _demographicBusiness = new DemographicBusiness(_mockContext.Object, _mockAssessmentUtil.Object);
        }

        [Fact]
        public void SaveDD_CreatesNewRecord_WhenRecordDoesNotExist()
        {
            // Arrange
            var assessmentId = 1;
            var key = "TEST-KEY";
            var value = "Test Value";
            var dataType = "string";

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicBusiness.SaveDD(assessmentId, key, value, dataType);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.Assessment_Id == assessmentId &&
                     d.DataItemName == key &&
                     d.StringValue == value
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void SaveDD_UpdatesExistingRecord_WhenRecordExists()
        {
            // Arrange
            var assessmentId = 1;
            var key = "EXISTING-KEY";
            var oldValue = "Old Value";
            var newValue = "New Value";
            var dataType = "string";

            var existingRecord = new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = assessmentId,
                DataItemName = key,
                StringValue = oldValue
            };

            var demographics = new List<DETAILS_DEMOGRAPHICS> { existingRecord };
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicBusiness.SaveDD(assessmentId, key, newValue, dataType);

            // Assert
            Assert.Equal(newValue, existingRecord.StringValue);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
            mockDemographicsSet.Verify(m => m.Add(It.IsAny<DETAILS_DEMOGRAPHICS>()), Times.Never);
        }

        [Fact]
        public void SaveDD_OverwritesValue_WhenCalledMultipleTimes()
        {
            // Arrange
            var assessmentId = 1;
            var key = "MULTI-SAVE-KEY";
            var value1 = "First Value";
            var value2 = "Second Value";
            var dataType = "string";

            var record = new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = assessmentId,
                DataItemName = key,
                StringValue = value1
            };

            var demographics = new List<DETAILS_DEMOGRAPHICS> { record };
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicBusiness.SaveDD(assessmentId, key, value2, dataType);

            // Assert
            Assert.Equal(value2, record.StringValue);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void SaveDD_HandlesEmptyValue()
        {
            // Arrange
            var assessmentId = 1;
            var key = "EMPTY-VALUE-KEY";
            var value = "";
            var dataType = "string";

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicBusiness.SaveDD(assessmentId, key, value, dataType);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.StringValue == ""
            )), Times.Once);
        }

        [Fact]
        public void SaveDD_HandlesNullValue()
        {
            // Arrange
            var assessmentId = 1;
            var key = "NULL-VALUE-KEY";
            string? value = null;
            var dataType = "string";

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicBusiness.SaveDD(assessmentId, key, value, dataType);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.StringValue == null
            )), Times.Once);
        }

        [Fact]
        public void SaveDD_WorksWithDifferentAssessmentIds()
        {
            // Arrange
            var assessmentId1 = 1;
            var assessmentId2 = 2;
            var key = "SAME-KEY";
            var value1 = "Value for Assessment 1";
            var value2 = "Value for Assessment 2";
            var dataType = "string";

            var record1 = new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = assessmentId1,
                DataItemName = key,
                StringValue = value1
            };

            var demographics = new List<DETAILS_DEMOGRAPHICS> { record1 };
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act - Saving for a different assessment should create a new record
            _demographicBusiness.SaveDD(assessmentId2, key, value2, dataType);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.Assessment_Id == assessmentId2 &&
                     d.DataItemName == key &&
                     d.StringValue == value2
            )), Times.Once);
        }

        [Fact]
        public void SaveDD_OnlyUpdatesMatchingRecord()
        {
            // Arrange
            var assessmentId = 1;
            var key1 = "KEY-1";
            var key2 = "KEY-2";
            var value = "New Value";
            var dataType = "string";

            var record1 = new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = assessmentId,
                DataItemName = key1,
                StringValue = "Original Value 1"
            };

            var record2 = new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = assessmentId,
                DataItemName = key2,
                StringValue = "Original Value 2"
            };

            var demographics = new List<DETAILS_DEMOGRAPHICS> { record1, record2 };
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicBusiness.SaveDD(assessmentId, key1, value, dataType);

            // Assert
            Assert.Equal(value, record1.StringValue);
            Assert.Equal("Original Value 2", record2.StringValue); // Should remain unchanged
        }

        [Fact]
        public void GetDemographics_ReturnsBasicDemographics_WhenNoExtendedDataExists()
        {
            // Arrange
            var assessmentId = 1;

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var demographicOptions = new List<DETAILS_DEMOGRAPHICS_OPTIONS>();
            var sectorSubsectors = new List<ASSESSMENT_SECTOR_SUBSECTOR>();
            var sectors = new List<SECTOR>();

            var mockDemographicsSet = CreateMockDbSet(demographics);
            var mockOptionsSet = CreateMockDbSet(demographicOptions);
            var mockSectorSubsectorSet = CreateMockDbSet(sectorSubsectors);
            var mockSectorSet = CreateMockDbSet(sectors);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS_OPTIONS).Returns(mockOptionsSet.Object);
            _mockContext.Setup(c => c.ASSESSMENT_SECTOR_SUBSECTOR).Returns(mockSectorSubsectorSet.Object);
            _mockContext.Setup(c => c.SECTOR).Returns(mockSectorSet.Object);

            // Act
            var result = _demographicBusiness.GetDemographics(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(assessmentId, result.AssessmentId);
            Assert.Empty(result.SsgModelIds);
        }

        [Fact]
        public void GetDemographics_LoadsSsgSectors_WhenSsgDataExists()
        {
            // Arrange
            var assessmentId = 1;

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var demographicOptions = new List<DETAILS_DEMOGRAPHICS_OPTIONS>();

            // Sector 1 maps to Model_SSG_CHEM (18), Sector 13 maps to Model_SSG_IT (20)
            var sectorSubsectors = new List<ASSESSMENT_SECTOR_SUBSECTOR>
            {
                new ASSESSMENT_SECTOR_SUBSECTOR { Assessment_Id = assessmentId, SectorId = 1, Sequence = 1 },
                new ASSESSMENT_SECTOR_SUBSECTOR { Assessment_Id = assessmentId, SectorId = 13, Sequence = 2 }
            };
            var sectors = new List<SECTOR>();
            var sectorIndustries = new List<SECTOR_INDUSTRY>();

            var mockDemographicsSet = CreateMockDbSet(demographics);
            var mockOptionsSet = CreateMockDbSet(demographicOptions);
            var mockSectorSubsectorSet = CreateMockDbSet(sectorSubsectors);
            var mockSectorSet = CreateMockDbSet(sectors);
            var mockSectorIndustrySet = CreateMockDbSet(sectorIndustries);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS_OPTIONS).Returns(mockOptionsSet.Object);
            _mockContext.Setup(c => c.ASSESSMENT_SECTOR_SUBSECTOR).Returns(mockSectorSubsectorSet.Object);
            _mockContext.Setup(c => c.SECTOR).Returns(mockSectorSet.Object);
            _mockContext.Setup(c => c.SECTOR_INDUSTRY).Returns(mockSectorIndustrySet.Object);

            // Act
            var result = _demographicBusiness.GetDemographics(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.SsgModelIds.Count);
            Assert.Contains(18, result.SsgModelIds); // Model_SSG_CHEM
            Assert.Contains(20, result.SsgModelIds); // Model_SSG_IT
        }

        [Fact]
        public void SaveDemographics_TouchesAssessment()
        {
            // Arrange
            var assessmentId = 1;
            var demographics = new Demographics
            {
                AssessmentId = assessmentId,
                OrganizationName = "Test Org"
            };

            var detailsDemographics = new List<DETAILS_DEMOGRAPHICS>();
            var demographicOptions = new List<DETAILS_DEMOGRAPHICS_OPTIONS>();

            var mockDemographicsSet = CreateMockDbSet(detailsDemographics);
            var mockOptionsSet = CreateMockDbSet(demographicOptions);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS_OPTIONS).Returns(mockOptionsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            _demographicBusiness.SaveDemographics(demographics);

            // Assert
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void SaveDemographics_RemovesAndReplacesSSGSectors()
        {
            // Arrange
            var assessmentId = 1;
            var demographics = new Demographics
            {
                AssessmentId = assessmentId,
                SsgModelIds = new List<int> { 1, 2, 3 }
            };

            var existingSSG = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS { Assessment_Id = assessmentId, DataItemName = "SSG-SECTOR-4", IntValue = 4 },
                new DETAILS_DEMOGRAPHICS { Assessment_Id = assessmentId, DataItemName = "SSG-SECTOR-5", IntValue = 5 }
            };

            var demographicOptions = new List<DETAILS_DEMOGRAPHICS_OPTIONS>();

            var mockDemographicsSet = CreateMockDbSet(existingSSG);
            var mockOptionsSet = CreateMockDbSet(demographicOptions);

            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS_OPTIONS).Returns(mockOptionsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockContext.Setup(c => c.RemoveRange(It.IsAny<IEnumerable<DETAILS_DEMOGRAPHICS>>()));
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            _demographicBusiness.SaveDemographics(demographics);

            // Assert
            _mockContext.Verify(c => c.RemoveRange(It.IsAny<IEnumerable<DETAILS_DEMOGRAPHICS>>()), Times.Once);
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
