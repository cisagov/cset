////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Business.Demographic;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Demographic
{
    /// <summary>
    /// Unit tests for DemographicExtBusiness class.
    /// Tests extended demographic data management including GetX, SaveX, and subsector retrieval.
    /// </summary>
    public class DemographicExtBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly DemographicExtBusiness _demographicExtBusiness;

        public DemographicExtBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _demographicExtBusiness = new DemographicExtBusiness(_mockContext.Object);
        }

        [Fact]
        public void GetX_ReturnsStringValue_WhenStringValueExists()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "ORG-NAME";
            var expectedValue = "Test Organization";

            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = expectedValue,
                    IntValue = null,
                    FloatValue = null,
                    BoolValue = null,
                    DateTimeValue = null
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);

            // Act
            var result = _demographicExtBusiness.GetX(assessmentId, recName);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(expectedValue, result);
            Assert.IsType<string>(result);
        }

        [Fact]
        public void GetX_ReturnsIntValue_WhenIntValueExists()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "SECTOR";
            var expectedValue = 5;

            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = null,
                    IntValue = expectedValue,
                    FloatValue = null,
                    BoolValue = null,
                    DateTimeValue = null
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);

            // Act
            var result = _demographicExtBusiness.GetX(assessmentId, recName);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(expectedValue, result);
            Assert.IsType<int>(result);
        }

        [Fact]
        public void GetX_ReturnsFloatValue_WhenFloatValueExists()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "REVENUE";
            var expectedValue = 1000.50;

            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = null,
                    IntValue = null,
                    FloatValue = expectedValue,
                    BoolValue = null,
                    DateTimeValue = null
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);

            // Act
            var result = _demographicExtBusiness.GetX(assessmentId, recName);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(expectedValue, result);
            Assert.IsType<double>(result);
        }

        [Fact]
        public void GetX_ReturnsBoolValue_WhenBoolValueExists()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "SELF-ASSESS";
            var expectedValue = true;

            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = null,
                    IntValue = null,
                    FloatValue = null,
                    BoolValue = expectedValue,
                    DateTimeValue = null
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);

            // Act
            var result = _demographicExtBusiness.GetX(assessmentId, recName);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(expectedValue, result);
            Assert.IsType<bool>(result);
        }

        [Fact]
        public void GetX_ReturnsDateTimeValue_WhenDateTimeValueExists()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "ASSESSMENT-DATE";
            var expectedValue = new DateTime(2025, 1, 1);

            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = null,
                    IntValue = null,
                    FloatValue = null,
                    BoolValue = null,
                    DateTimeValue = expectedValue
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);

            // Act
            var result = _demographicExtBusiness.GetX(assessmentId, recName);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(expectedValue, result);
            Assert.IsType<DateTime>(result);
        }

        [Fact]
        public void GetX_ReturnsNull_WhenRecordNotFound()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "NON-EXISTENT";

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);

            // Act
            var result = _demographicExtBusiness.GetX(assessmentId, recName);

            // Assert
            Assert.Null(result);
        }

        [Fact]
        public void GetX_ReturnsNull_WhenAllValuesAreNull()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "EMPTY-RECORD";

            var demographics = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = null,
                    IntValue = null,
                    FloatValue = null,
                    BoolValue = null,
                    DateTimeValue = null
                }
            };

            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);

            // Act
            var result = _demographicExtBusiness.GetX(assessmentId, recName);

            // Assert
            Assert.Null(result);
        }

        [Fact]
        public void SaveX_CreatesNewRecord_WhenRecordDoesNotExist()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "NEW-FIELD";
            var value = "Test Value";

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicExtBusiness.SaveX(assessmentId, recName, value);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.Assessment_Id == assessmentId &&
                     d.DataItemName == recName &&
                     d.StringValue == value
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void SaveX_UpdatesExistingRecord_WhenRecordExists()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "EXISTING-FIELD";
            var oldValue = "Old Value";
            var newValue = "New Value";

            var existingRecord = new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                StringValue = oldValue
            };

            var demographics = new List<DETAILS_DEMOGRAPHICS> { existingRecord };
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicExtBusiness.SaveX(assessmentId, recName, newValue);

            // Assert
            Assert.Equal(newValue, existingRecord.StringValue);
            Assert.Null(existingRecord.IntValue);
            Assert.Null(existingRecord.FloatValue);
            Assert.Null(existingRecord.BoolValue);
            Assert.Null(existingRecord.DateTimeValue);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void SaveX_StoresIntValue_WhenValueIsInt()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "INT-FIELD";
            var value = 42;

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicExtBusiness.SaveX(assessmentId, recName, value);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.IntValue == value && d.StringValue == null
            )), Times.Once);
        }

        [Fact]
        public void SaveX_StoresDoubleValue_WhenValueIsDouble()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "DOUBLE-FIELD";
            var value = 3.14;

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicExtBusiness.SaveX(assessmentId, recName, value);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.FloatValue == value && d.StringValue == null
            )), Times.Once);
        }

        [Fact]
        public void SaveX_StoresBoolValue_WhenValueIsBool()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "BOOL-FIELD";
            var value = true;

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicExtBusiness.SaveX(assessmentId, recName, value);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.BoolValue == value && d.StringValue == null
            )), Times.Once);
        }

        [Fact]
        public void SaveX_StoresDateTimeValue_WhenValueIsDateTime()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "DATE-FIELD";
            var value = new DateTime(2025, 1, 1);

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicExtBusiness.SaveX(assessmentId, recName, value);

            // Assert
            mockDemographicsSet.Verify(m => m.Add(It.Is<DETAILS_DEMOGRAPHICS>(
                d => d.DateTimeValue == value && d.StringValue == null
            )), Times.Once);
        }

        [Fact]
        public void SaveX_ReturnsEarly_WhenValueIsNull()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "NULL-FIELD";
            object? value = null;

            var demographics = new List<DETAILS_DEMOGRAPHICS>();
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);

            // Act
            _demographicExtBusiness.SaveX(assessmentId, recName, value);

            // Assert - SaveChanges should not be called when value is null and record doesn't exist
            // Because the method returns early after clearing all values
        }

        [Fact]
        public void SaveX_ClearsAllValues_WhenUpdatingRecord()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "CLEAR-FIELD";

            var existingRecord = new DETAILS_DEMOGRAPHICS
            {
                Assessment_Id = assessmentId,
                DataItemName = recName,
                StringValue = "old",
                IntValue = 123,
                FloatValue = 45.6,
                BoolValue = true,
                DateTimeValue = DateTime.Now
            };

            var demographics = new List<DETAILS_DEMOGRAPHICS> { existingRecord };
            var mockDemographicsSet = CreateMockDbSet(demographics);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicExtBusiness.SaveX(assessmentId, recName, "new value");

            // Assert
            Assert.Equal("new value", existingRecord.StringValue);
            Assert.Null(existingRecord.IntValue);
            Assert.Null(existingRecord.FloatValue);
            Assert.Null(existingRecord.BoolValue);
            Assert.Null(existingRecord.DateTimeValue);
        }

        [Fact]
        public void RemoveX_DeletesRecords_WhenRecordsExist()
        {
            // Arrange
            var assessmentId = 1;
            var recName = "REMOVE-FIELD";

            var records = new List<DETAILS_DEMOGRAPHICS>
            {
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = "value1"
                },
                new DETAILS_DEMOGRAPHICS
                {
                    Assessment_Id = assessmentId,
                    DataItemName = recName,
                    StringValue = "value2"
                }
            };

            var mockDemographicsSet = CreateMockDbSet(records);
            _mockContext.Setup(c => c.DETAILS_DEMOGRAPHICS).Returns(mockDemographicsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _demographicExtBusiness.RemoveX(assessmentId, recName);

            // Assert
            mockDemographicsSet.Verify(m => m.RemoveRange(It.IsAny<IEnumerable<DETAILS_DEMOGRAPHICS>>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void GetSubsectors_ReturnsSortedList_WithOtherItemsAtEnd()
        {
            // Arrange
            var sectorId = 1;
            var subsectors = new List<SECTOR_INDUSTRY>
            {
                new SECTOR_INDUSTRY { SectorId = sectorId, IndustryId = 1, IndustryName = "Banking", Is_Other = false },
                new SECTOR_INDUSTRY { SectorId = sectorId, IndustryId = 2, IndustryName = "Other", Is_Other = true },
                new SECTOR_INDUSTRY { SectorId = sectorId, IndustryId = 3, IndustryName = "Insurance", Is_Other = false },
                new SECTOR_INDUSTRY { SectorId = sectorId, IndustryId = 4, IndustryName = "Other Services", Is_Other = true },
                new SECTOR_INDUSTRY { SectorId = sectorId, IndustryId = 5, IndustryName = "Legacy NIPP", Is_NIPP = true }
            };

            var mockSubsectorSet = CreateMockDbSet(subsectors);
            _mockContext.Setup(c => c.SECTOR_INDUSTRY).Returns(mockSubsectorSet.Object);

            // Act
            var result = _demographicExtBusiness.GetSubsectors(sectorId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(4, result.Count);
            // "Other" items should be at the end
            Assert.Equal("Banking", result[0].OptionText);
            Assert.Equal("Insurance", result[1].OptionText);
            Assert.Contains("Other", result[2].OptionText);
            Assert.Contains("Other", result[3].OptionText);
            Assert.DoesNotContain(result, x => x.OptionText == "Legacy NIPP");
        }

        [Fact]
        public void GetSubsectors_ReturnsEmpty_WhenNoSubsectorsExist()
        {
            // Arrange
            var sectorId = 999;
            var subsectors = new List<SECTOR_INDUSTRY>();

            var mockSubsectorSet = CreateMockDbSet(subsectors);
            _mockContext.Setup(c => c.SECTOR_INDUSTRY).Returns(mockSubsectorSet.Object);

            // Act
            var result = _demographicExtBusiness.GetSubsectors(sectorId);

            // Assert
            Assert.NotNull(result);
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
