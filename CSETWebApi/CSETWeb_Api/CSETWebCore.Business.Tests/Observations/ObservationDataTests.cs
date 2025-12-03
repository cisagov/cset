using CSETWebCore.Business.Observations;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Observations;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Observations
{
    /// <summary>
    /// Unit tests for ObservationData class.
    /// Tests observation data persistence, updates, and contact management.
    /// </summary>
    public class ObservationDataTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;

        public ObservationDataTests()
        {
            _mockContext = new Mock<CSETContext>();
        }

        #region Constructor Tests - New Observation

        [Fact]
        public void Constructor_CreatesNewFinding_WhenObservationIdDoesNotExist()
        {
            // Arrange
            var observation = new Observation
            {
                Observation_Id = 0,
                Assessment_Id = 1,
                Summary = "New observation",
                Issue = "New issue",
                Importance_Id = 2,
                Impact = "High impact",
                Recommendations = "Fix this"
            };

            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 2, Value = "Medium" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            mockFindingSet.Verify(m => m.Add(It.Is<FINDING>(
                f => f.Assessment_Id == 1 &&
                     f.Summary == "New observation" &&
                     f.Issue == "New issue" &&
                     f.Importance_Id == 2 &&
                     f.Impact == "High impact" &&
                     f.Recommendations == "Fix this"
            )), Times.Once);
        }

        [Fact]
        public void Constructor_NullsImportanceId_WhenImportanceIdIsZero()
        {
            // Arrange
            var observation = new Observation
            {
                Observation_Id = 0,
                Assessment_Id = 1,
                Summary = "Test",
                Importance_Id = 0
            };

            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            mockFindingSet.Verify(m => m.Add(It.Is<FINDING>(
                f => f.Importance_Id == null
            )), Times.Once);
        }

        [Fact]
        public void Constructor_SetsAllObservationFields_WhenCreatingNewFinding()
        {
            // Arrange
            var resolutionDate = DateTime.Now;
            var observation = new Observation
            {
                Observation_Id = 0,
                Assessment_Id = 1,
                Answer_Id = 123,
                Summary = "Summary text",
                Issue = "Issue text",
                Impact = "Impact text",
                Recommendations = "Recommendations text",
                Vulnerabilities = "Vulnerabilities text",
                Resolution_Date = resolutionDate,
                Title = "Title text",
                Type = "Type text",
                Risk_Area = "Risk area text",
                Sub_Risk = "Sub risk text",
                Description = "Description text",
                Citations = "Citations text",
                ActionItems = "Action items text",
                Supp_Guidance = "Supplemental guidance text",
                Importance_Id = 3
            };

            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 3, Value = "High" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            mockFindingSet.Verify(m => m.Add(It.Is<FINDING>(
                f => f.Assessment_Id == 1 &&
                     f.Answer_Id == 123 &&
                     f.Summary == "Summary text" &&
                     f.Issue == "Issue text" &&
                     f.Impact == "Impact text" &&
                     f.Recommendations == "Recommendations text" &&
                     f.Vulnerabilities == "Vulnerabilities text" &&
                     f.Resolution_Date == resolutionDate &&
                     f.Title == "Title text" &&
                     f.Type == "Type text" &&
                     f.Risk_Area == "Risk area text" &&
                     f.Sub_Risk == "Sub risk text" &&
                     f.Description == "Description text" &&
                     f.Citations == "Citations text" &&
                     f.ActionItems == "Action items text" &&
                     f.Supp_Guidance == "Supplemental guidance text"
            )), Times.Once);
        }

        #endregion

        #region Constructor Tests - Existing Observation

        [Fact]
        public void Constructor_UpdatesExistingFinding_WhenObservationIdExists()
        {
            // Arrange
            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Original summary",
                Issue = "Original issue",
                Importance_Id = 1,
                FINDING_CONTACT = new List<FINDING_CONTACT>()
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 2, Value = "Medium" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Updated summary",
                Issue = "Updated issue",
                Importance_Id = 2
            };

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            mockFindingSet.Verify(m => m.Add(It.IsAny<FINDING>()), Times.Never);
        }

        #endregion

        #region Contact Management Tests

        [Fact]
        public void Constructor_AddsNewContact_WhenContactIsSelected()
        {
            // Arrange
            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Test",
                FINDING_CONTACT = new List<FINDING_CONTACT>()
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = 1,
                Observation_Contacts = new List<ObservationContact>
                {
                    new ObservationContact
                    {
                        Assessment_Contact_Id = 100,
                        Selected = true
                    }
                }
            };

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            Assert.Single(existingFinding.FINDING_CONTACT);
            Assert.Equal(100, existingFinding.FINDING_CONTACT.First().Assessment_Contact_Id);
        }

        [Fact]
        public void Constructor_RemovesContact_WhenContactIsNotSelected()
        {
            // Arrange
            var existingContact = new FINDING_CONTACT
            {
                Finding_Id = 1,
                Assessment_Contact_Id = 100
            };

            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Test",
                FINDING_CONTACT = new List<FINDING_CONTACT> { existingContact }
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = 1,
                Observation_Contacts = new List<ObservationContact>
                {
                    new ObservationContact
                    {
                        Assessment_Contact_Id = 100,
                        Selected = false
                    }
                }
            };

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            Assert.Empty(existingFinding.FINDING_CONTACT);
        }

        [Fact]
        public void Constructor_DoesNotAddDuplicateContact_WhenContactAlreadyExists()
        {
            // Arrange
            var existingContact = new FINDING_CONTACT
            {
                Finding_Id = 1,
                Assessment_Contact_Id = 100
            };

            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Test",
                FINDING_CONTACT = new List<FINDING_CONTACT> { existingContact }
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = 1,
                Observation_Contacts = new List<ObservationContact>
                {
                    new ObservationContact
                    {
                        Assessment_Contact_Id = 100,
                        Selected = true
                    }
                }
            };

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            Assert.Single(existingFinding.FINDING_CONTACT);
        }

        [Fact]
        public void Constructor_HandlesMultipleContacts()
        {
            // Arrange
            var existingContact1 = new FINDING_CONTACT
            {
                Finding_Id = 1,
                Assessment_Contact_Id = 100
            };

            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Test",
                FINDING_CONTACT = new List<FINDING_CONTACT> { existingContact1 }
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = 1,
                Observation_Contacts = new List<ObservationContact>
                {
                    new ObservationContact { Assessment_Contact_Id = 100, Selected = false }, // Remove existing
                    new ObservationContact { Assessment_Contact_Id = 200, Selected = true },  // Add new
                    new ObservationContact { Assessment_Contact_Id = 300, Selected = true }   // Add new
                }
            };

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            Assert.Equal(2, existingFinding.FINDING_CONTACT.Count);
            Assert.Contains(existingFinding.FINDING_CONTACT, c => c.Assessment_Contact_Id == 200);
            Assert.Contains(existingFinding.FINDING_CONTACT, c => c.Assessment_Contact_Id == 300);
            Assert.DoesNotContain(existingFinding.FINDING_CONTACT, c => c.Assessment_Contact_Id == 100);
        }

        [Fact]
        public void Constructor_HandlesNullObservationContacts()
        {
            // Arrange
            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Test",
                FINDING_CONTACT = new List<FINDING_CONTACT>()
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = 1,
                Observation_Contacts = null
            };

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert - Should not throw exception
            Assert.NotNull(observationData);
        }

        #endregion

        #region Importance Tests

        [Fact]
        public void Constructor_SetsDefaultImportance_WhenImportanceIdIsNull()
        {
            // Arrange
            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Test",
                Importance_Id = null,
                FINDING_CONTACT = new List<FINDING_CONTACT>()
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = null
            };

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            Assert.NotNull(existingFinding.Importance);
            Assert.Equal(1, existingFinding.Importance.Importance_Id);
        }

        [Fact]
        public void Constructor_SetsCorrectImportance_WhenImportanceIdIsProvided()
        {
            // Arrange
            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Test",
                FINDING_CONTACT = new List<FINDING_CONTACT>()
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importanceList = new List<IMPORTANCE>
            {
                new IMPORTANCE { Importance_Id = 1, Value = "Low" },
                new IMPORTANCE { Importance_Id = 2, Value = "Medium" },
                new IMPORTANCE { Importance_Id = 3, Value = "High" }
            };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = 3
            };

            // Act
            var observationData = new ObservationData(observation, _mockContext.Object);

            // Assert
            Assert.NotNull(existingFinding.Importance);
            Assert.Equal(3, existingFinding.Importance.Importance_Id);
            Assert.Equal("High", existingFinding.Importance.Value);
        }

        #endregion

        #region Save Tests

        [Fact]
        public void Save_CallsSaveChanges_AndReturnsFindingId()
        {
            // Arrange
            var existingFinding = new FINDING
            {
                Finding_Id = 42,
                Assessment_Id = 1,
                Summary = "Test",
                FINDING_CONTACT = new List<FINDING_CONTACT>()
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            var observation = new Observation
            {
                Observation_Id = 42,
                Summary = "Test",
                Importance_Id = 1
            };

            var observationData = new ObservationData(observation, _mockContext.Object);

            // Act
            var result = observationData.Save();

            // Assert
            Assert.Equal(42, result);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        #endregion

        #region Delete Tests

        [Fact]
        public void Delete_RemovesFinding_AndCallsSaveChanges()
        {
            // Arrange
            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "To be deleted",
                FINDING_CONTACT = new List<FINDING_CONTACT>()
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = 1
            };

            var observationData = new ObservationData(observation, _mockContext.Object);

            // Act
            observationData.Delete();

            // Assert
            mockFindingSet.Verify(m => m.Remove(It.Is<FINDING>(f => f.Finding_Id == 1)), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void Delete_HandlesException_Gracefully()
        {
            // Arrange
            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Assessment_Id = 1,
                Summary = "Test",
                FINDING_CONTACT = new List<FINDING_CONTACT>()
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var importanceList = new List<IMPORTANCE> { importance };
            var mockImportanceSet = CreateMockDbSet(importanceList);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(mockImportanceSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Throws(new Exception("Database error"));

            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Test",
                Importance_Id = 1
            };

            var observationData = new ObservationData(observation, _mockContext.Object);

            // Act - Should not throw exception
            observationData.Delete();

            // Assert
            mockFindingSet.Verify(m => m.Remove(It.IsAny<FINDING>()), Times.Once);
        }

        #endregion

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
