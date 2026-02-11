////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Business.Assessment;

namespace CSETWebCore.Business.Tests.Assessment
{
    /// <summary>
    /// Unit tests for StandardsResponse DTOs.
    /// These are simple data models, so tests focus on initialization and properties.
    /// </summary>
    public class StandardsResponseTests
    {
        [Fact]
        public void StandardsResponse_CanBeInstantiated()
        {
            // Act
            var response = new StandardsResponse();

            // Assert
            Assert.NotNull(response);
        }

        [Fact]
        public void StandardsResponse_PropertiesCanBeSet()
        {
            // Arrange
            var response = new StandardsResponse
            {
                QuestionCount = 100,
                RequirementCount = 50
            };

            // Act & Assert
            Assert.Equal(100, response.QuestionCount);
            Assert.Equal(50, response.RequirementCount);
        }

        [Fact]
        public void StandardCategory_Constructor_InitializesStandardsList()
        {
            // Act
            var category = new StandardCategory();

            // Assert
            Assert.NotNull(category);
            Assert.NotNull(category.Standards);
            Assert.Empty(category.Standards);
        }

        [Fact]
        public void StandardCategory_PropertiesCanBeSetAndRetrieved()
        {
            // Arrange
            var category = new StandardCategory
            {
                CategoryName = "Network Security"
            };

            // Act
            category.Standards.Add(new Standard { Code = "NIST", FullName = "NIST Cybersecurity Framework" });

            // Assert
            Assert.Equal("Network Security", category.CategoryName);
            Assert.Single(category.Standards);
            Assert.Equal("NIST", category.Standards[0].Code);
        }

        [Fact]
        public void Standard_AllPropertiesCanBeSet()
        {
            // Act
            var standard = new Standard
            {
                Code = "CSF",
                FullName = "Cybersecurity Framework",
                Description = "NIST CSF v1.1",
                Selected = true,
                Recommended = false
            };

            // Assert
            Assert.Equal("CSF", standard.Code);
            Assert.Equal("Cybersecurity Framework", standard.FullName);
            Assert.Equal("NIST CSF v1.1", standard.Description);
            Assert.True(standard.Selected);
            Assert.False(standard.Recommended);
        }

        [Fact]
        public void StandardCategory_CanHoldMultipleStandards()
        {
            // Arrange
            var category = new StandardCategory
            {
                CategoryName = "Frameworks"
            };

            // Act
            category.Standards.Add(new Standard { Code = "NIST", FullName = "NIST CSF" });
            category.Standards.Add(new Standard { Code = "ISO", FullName = "ISO 27001" });
            category.Standards.Add(new Standard { Code = "CIS", FullName = "CIS Controls" });

            // Assert
            Assert.Equal(3, category.Standards.Count);
            Assert.Contains(category.Standards, s => s.Code == "NIST");
            Assert.Contains(category.Standards, s => s.Code == "ISO");
            Assert.Contains(category.Standards, s => s.Code == "CIS");
        }
    }
}
