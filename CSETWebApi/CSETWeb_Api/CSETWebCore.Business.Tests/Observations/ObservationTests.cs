using CSETWebCore.Model.Observations;

namespace CSETWebCore.Business.Tests.Observations
{
    /// <summary>
    /// Unit tests for Observation model class.
    /// Tests observation validation logic and empty state detection.
    /// </summary>
    public class ObservationTests
    {
        #region IsObservationEmpty Tests

        [Fact]
        public void IsObservationEmpty_ReturnsTrue_WhenAllFieldsAreEmpty()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsTrue_WhenAllFieldsAreWhitespace()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = "   ",
                Issue = "  ",
                Recommendations = "",
                Summary = "\t",
                Vulnerabilities = "\n",
                Resolution_Date = null,
                Title = "    ",
                Type = null,
                Description = "",
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenSummaryHasValue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = "Has summary",
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenIssueHasValue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = "Has issue",
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenRecommendationsHasValue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = "Has recommendations",
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenImpactHasValue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = "Has impact",
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenVulnerabilitiesHasValue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = "Has vulnerabilities",
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenResolutionDateHasValue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = DateTime.Now,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenTitleHasValue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = "Has title",
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenDescriptionHasValue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = "Has description",
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenSelectedContactExists()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>
                {
                    new ObservationContact
                    {
                        Assessment_Contact_Id = 1,
                        Selected = true
                    }
                }
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsTrue_WhenOnlyUnselectedContactsExist()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>
                {
                    new ObservationContact
                    {
                        Assessment_Contact_Id = 1,
                        Selected = false
                    },
                    new ObservationContact
                    {
                        Assessment_Contact_Id = 2,
                        Selected = false
                    }
                }
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsTrue_WhenCancelIsTrue()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = "Has impact",
                Issue = "Has issue",
                Recommendations = "Has recommendations",
                Summary = "Has summary",
                Vulnerabilities = "Has vulnerabilities",
                Resolution_Date = DateTime.Now,
                Title = "Has title",
                Type = "Has type",
                Description = "Has description",
                Observation_Contacts = new List<ObservationContact>
                {
                    new ObservationContact
                    {
                        Assessment_Contact_Id = 1,
                        Selected = true
                    }
                }
            };

            // Act
            var result = observation.IsObservationEmpty(cancel: true);

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenMultipleFieldsHaveValues()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = "Impact text",
                Issue = "Issue text",
                Recommendations = "Recommendations text",
                Summary = "Summary text",
                Vulnerabilities = null,
                Resolution_Date = DateTime.Now,
                Title = null,
                Type = null,
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_HandlesMixedWhitespaceAndValues()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = "   ",
                Issue = "",
                Recommendations = null,
                Summary = "Has value",
                Vulnerabilities = "\t",
                Resolution_Date = null,
                Title = null,
                Type = null,
                Description = "  ",
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsObservationEmpty_ReturnsFalse_WhenTypeIsNotNull()
        {
            // Arrange
            var observation = new Observation
            {
                Impact = null,
                Issue = null,
                Recommendations = null,
                Summary = null,
                Vulnerabilities = null,
                Resolution_Date = null,
                Title = null,
                Type = "Some type",
                Description = null,
                Observation_Contacts = new List<ObservationContact>()
            };

            // Act
            var result = observation.IsObservationEmpty();

            // Assert
            Assert.False(result);
        }

        #endregion
    }
}
