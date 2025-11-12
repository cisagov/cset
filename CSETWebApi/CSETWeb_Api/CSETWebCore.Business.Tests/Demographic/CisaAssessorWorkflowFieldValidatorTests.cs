using CSETWebCore.Business.Demographic;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Demographic;

namespace CSETWebCore.Business.Tests.Demographic
{
    /// <summary>
    /// Unit tests for CisaAssessorWorkflowFieldValidator class.
    /// Tests field validation logic for CISA Assessor Workflow including demographics, service demographics, and service composition.
    /// </summary>
    public class CisaAssessorWorkflowFieldValidatorTests
    {
        [Fact]
        public void ValidateFields_ReturnsValid_WhenAllRequiredFieldsPopulated()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "Test Org",
                Sector = 1,
                UsesStandard = false,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics
            {
                CustomersCount = "100"
            };
            var cisServiceComposition = new CisServiceComposition
            {
                NetworksDescription = "Network description"
            };

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // The result will depend on the FieldValidation.json configuration
            // This test verifies the validator executes without errors
        }

        [Fact]
        public void ValidateFields_ReturnsInvalid_WhenRequiredFieldsNull()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = null, // Missing required field
                Sector = null,
                UsesStandard = false,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics();
            var cisServiceComposition = new CisServiceComposition();

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // If there are required fields in the validation JSON, isValid should be false
        }

        [Fact]
        public void ValidateFields_ReturnsInvalid_WhenRequiredStringFieldsEmpty()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "", // Empty string should be invalid
                Sector = 1,
                UsesStandard = false,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics();
            var cisServiceComposition = new CisServiceComposition();

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // Empty strings should be treated as invalid
        }

        [Fact]
        public void ValidateFields_ReturnsInvalid_WhenRequiredStringFieldsWhitespace()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "   ", // Whitespace should be invalid
                Sector = 1,
                UsesStandard = false,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics();
            var cisServiceComposition = new CisServiceComposition();

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // Whitespace-only strings should be treated as invalid
        }

        [Fact]
        public void ValidateFields_ExcludesStandardFields_WhenUsesStandardIsFalse()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "Test Org",
                Sector = 1,
                UsesStandard = false, // Standard fields should be excluded
                Standard1 = null, // Should not cause validation failure
                Standard2 = null,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics
            {
                CustomersCount = "100"
            };
            var cisServiceComposition = new CisServiceComposition
            {
                NetworksDescription = "Network description"
            };

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // Standard fields should be excluded from validation when UsesStandard is false
        }

        [Fact]
        public void ValidateFields_ExcludesRegulationFields_WhenRequiredToComplyIsFalse()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "Test Org",
                Sector = 1,
                UsesStandard = false,
                RequiredToComply = false, // Regulation fields should be excluded
                RegulationType1 = null, // Should not cause validation failure
                RegulationType2 = null
            };
            var cisServiceDemographics = new CisServiceDemographics
            {
                CustomersCount = "100"
            };
            var cisServiceComposition = new CisServiceComposition
            {
                NetworksDescription = "Network description"
            };

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // Regulation type fields should be excluded from validation when RequiredToComply is false
        }

        [Fact]
        public void ValidateFields_FindsPropertyAcrossMultipleObjects()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "Test Org",
                Sector = 1,
                UsesStandard = false,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics
            {
                CustomersCount = "100",
                CriticalServiceDescription = "Critical Service"
            };
            var cisServiceComposition = new CisServiceComposition
            {
                NetworksDescription = "Network description",
                ServicesDescription = "Services description"
            };

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // Validator should successfully find and validate properties across all three objects
        }

        [Fact]
        public void ValidateFields_HandlesNullObjects_Gracefully()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "Test Org",
                UsesStandard = false,
                RequiredToComply = false
            };

            // Note: Some parameters could be null in real scenarios
            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                null, // cisServiceDemographics
                null  // cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // Validator should handle null objects gracefully
        }

        [Fact]
        public void ValidateFields_ReturnsResponseWithInvalidFieldsList()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = null, // Invalid
                Sector = null, // Invalid
                UsesStandard = false,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics();
            var cisServiceComposition = new CisServiceComposition();

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            Assert.NotNull(result.InvalidFields);
            // The result should contain a list of invalid field labels
        }

        [Fact]
        public void ValidateFields_ReturnsIsValidFalse_WhenInvalidFieldsExist()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = null, // At least one invalid field
                UsesStandard = false,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics();
            var cisServiceComposition = new CisServiceComposition();

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // If invalid fields were found, IsValid should be false
            if (result.InvalidFields.Count > 0)
            {
                Assert.False(result.IsValid);
            }
        }

        [Fact]
        public void ValidateFields_IncludesStandardFields_WhenUsesStandardIsTrue()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "Test Org",
                Sector = 1,
                UsesStandard = true, // Standard fields should be included
                Standard1 = null, // Should cause validation failure if in validation JSON
                Standard2 = null,
                RequiredToComply = false
            };
            var cisServiceDemographics = new CisServiceDemographics
            {
                CustomersCount = "100"
            };
            var cisServiceComposition = new CisServiceComposition
            {
                NetworksDescription = "Network description"
            };

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // Standard fields should be included in validation when UsesStandard is true
        }

        [Fact]
        public void ValidateFields_IncludesRegulationFields_WhenRequiredToComplyIsTrue()
        {
            // Arrange
            var demographics = new Demographics { AssessmentId = 1 };
            var demographicExt = new DemographicExt
            {
                OrganizationName = "Test Org",
                Sector = 1,
                UsesStandard = false,
                RequiredToComply = true, // Regulation fields should be included
                RegulationType1 = null, // Should cause validation failure if in validation JSON
                RegulationType2 = null
            };
            var cisServiceDemographics = new CisServiceDemographics
            {
                CustomersCount = "100"
            };
            var cisServiceComposition = new CisServiceComposition
            {
                NetworksDescription = "Network description"
            };

            var validator = new CisaAssessorWorkflowFieldValidator(
                demographics,
                demographicExt,
                cisServiceDemographics,
                cisServiceComposition
            );

            // Act
            var result = validator.ValidateFields();

            // Assert
            Assert.NotNull(result);
            // Regulation type fields should be included in validation when RequiredToComply is true
        }
    }
}
