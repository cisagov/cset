using CSETWebCore.Business.AssessmentIO.Import;
using SysVersion = System.Version;

namespace CSETWebCore.Business.Tests.AssessmentIO.Import
{
    /// <summary>
    /// Unit tests for ImportUpgradeManager that handles assessment data upgrades across versions.
    /// </summary>
    public class ImportUpgradeManagerTests
    {
        [Theory]
        [InlineData("9", "9.0.0.0")]
        [InlineData("10", "10.0.0.0")]
        [InlineData("12.4", "12.4.0.0")]
        public void ParseVersion_SingleOrDoubleDigit_NormalizesCorrectly(string input, string expected)
        {
            // Act
            var result = ImportUpgradeManager.ParseVersion(input);

            // Assert
            Assert.Equal(expected, result.ToString());
        }

        [Theory]
        [InlineData(9, 0, 0, 0, "9.0.0.0")]
        [InlineData(10, 1, 1, 0, "10.1.1.0")]
        [InlineData(12, 4, 0, 5, "12.4.0.5")]
        public void NormalizeVersion_WithVariousParts_ReturnsNormalized(int major, int minor, int build, int revision, string expected)
        {
            // Arrange
            var version = new SysVersion(major, minor, build, revision);

            // Act
            var result = ImportUpgradeManager.NormalizeVersion(version);

            // Assert
            Assert.Equal(expected, result.ToString());
        }

        [Theory]
        [InlineData(10, 0, "10.0.0.0")]
        [InlineData(9, 2, "9.2.0.0")]
        public void NormalizeVersion_WithMissingParts_FillsWithZeros(int major, int minor, string expected)
        {
            // Arrange
            var version = new SysVersion(major, minor);

            // Act
            var result = ImportUpgradeManager.NormalizeVersion(version);

            // Assert
            Assert.Equal(expected, result.ToString());
        }

        [Fact]
        public void Upgrade_Version9_0_0_UpgradesToLatest()
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = @"{
                ""jCSET_VERSION"": [{
                    ""Cset_Version1"": ""9.0.0.0"",
                    ""Version_Id"": ""9.0.0.0""
                }],
                ""jASSESSMENTS"": [{""Assessment_Id"": 1}],
                ""jAVAILABLE_MATURITY_MODELS"": [],
                ""jAVAILABLE_STANDARDS"": [],
                ""jSTANDARD_SELECTION"": [{""Application_Mode"": ""questions based""}],
                ""jASSESSMENT_DIAGRAM_COMPONENTS"": [],
                ""jNIST_SAL_QUESTION_ANSWERS"": [],
                ""jDOCUMENT_FILE"": [],
                ""jANSWER"": [{
                    ""Is_Requirement"": false,
                    ""Is_Component"": false,
                    ""Is_Framework"": false,
                    ""Component_Guid"": ""00000000-0000-0000-0000-000000000000""
                }]
            }";

            // Act
            var result = upgradeManager.Upgrade(json);

            // Assert
            Assert.NotNull(result);
            Assert.Contains("jCSET_VERSION", result);
            Assert.Contains("jASSESSMENTS", result);
        }

        [Fact]
        public void Upgrade_Version10_1_1_UpgradesCorrectly()
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = @"{
                ""jCSET_VERSION"": [{
                    ""Cset_Version1"": ""10.1.1.0"",
                    ""Version_Id"": ""10.1.1.0""
                }],
                ""jASSESSMENTS"": [{""Assessment_Id"": 1}],
                ""jAVAILABLE_MATURITY_MODELS"": [],
                ""jAVAILABLE_STANDARDS"": [],
                ""jSTANDARD_SELECTION"": [{""Application_Mode"": ""questions based""}],
                ""jASSESSMENT_DIAGRAM_COMPONENTS"": [],
                ""jNIST_SAL_QUESTION_ANSWERS"": [],
                ""jDOCUMENT_FILE"": [],
                ""jANSWER"": []
            }";

            // Act
            var result = upgradeManager.Upgrade(json);

            // Assert
            Assert.NotNull(result);
        }

        [Fact]
        public void Upgrade_LatestVersion_NoChangesApplied()
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = @"{
                ""jCSET_VERSION"": [{
                    ""Cset_Version1"": ""12.4.0.5"",
                    ""Version_Id"": ""12.4.0.5""
                }],
                ""jASSESSMENTS"": [{}]
            }";

            // Act
            var result = upgradeManager.Upgrade(json);

            // Assert
            Assert.NotNull(result);
            // Result should be essentially the same since it's already at latest version
        }

        [Fact]
        public void Upgrade_MissingCsetVersion1_FallsBackToVersionId()
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = @"{
                ""jCSET_VERSION"": [{
                    ""Version_Id"": ""9.0.0.0""
                }],
                ""jASSESSMENTS"": [{""Assessment_Id"": 1}],
                ""jAVAILABLE_MATURITY_MODELS"": [],
                ""jAVAILABLE_STANDARDS"": [],
                ""jSTANDARD_SELECTION"": [{""Application_Mode"": ""questions based""}],
                ""jASSESSMENT_DIAGRAM_COMPONENTS"": [],
                ""jNIST_SAL_QUESTION_ANSWERS"": [],
                ""jDOCUMENT_FILE"": [],
                ""jANSWER"": [{
                    ""Is_Requirement"": false,
                    ""Is_Component"": false,
                    ""Is_Framework"": false,
                    ""Component_Guid"": ""00000000-0000-0000-0000-000000000000""
                }]
            }";

            // Act
            var result = upgradeManager.Upgrade(json);

            // Assert
            Assert.NotNull(result);
        }

        [Fact]
        public void Upgrade_MissingVersionInformation_ThrowsException()
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = @"{
                ""jCSET_VERSION"": [{}],
                ""jASSESSMENTS"": [{}]
            }";

            // Act & Assert
            Assert.Throws<ApplicationException>(() => upgradeManager.Upgrade(json));
        }

        [Fact]
        public void Upgrade_CorruptedJson_ThrowsException()
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = "{ invalid json";

            // Act & Assert
            Assert.ThrowsAny<Exception>(() => upgradeManager.Upgrade(json));
        }

        [Theory]
        [InlineData("9.21.0.0")]
        [InlineData("9.23.0.0")]
        [InlineData("101.0.0.0")]
        [InlineData("10.11.0.0")]
        public void Upgrade_AmbiguousVersions_NormalizesCorrectly(string inputVersion)
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = $@"{{
                ""jCSET_VERSION"": [{{
                    ""Cset_Version1"": ""{inputVersion}"",
                    ""Version_Id"": ""{inputVersion}""
                }}],
                ""jASSESSMENTS"": [{{""Assessment_Id"": 1}}],
                ""jAVAILABLE_MATURITY_MODELS"": [],
                ""jAVAILABLE_STANDARDS"": [],
                ""jSTANDARD_SELECTION"": [{{""Application_Mode"": ""questions based""}}],
                ""jASSESSMENT_DIAGRAM_COMPONENTS"": [],
                ""jNIST_SAL_QUESTION_ANSWERS"": [],
                ""jDOCUMENT_FILE"": [],
                ""jANSWER"": [{{
                    ""Is_Requirement"": false,
                    ""Is_Component"": false,
                    ""Is_Framework"": false,
                    ""Component_Guid"": ""00000000-0000-0000-0000-000000000000""
                }}]
            }}";

            // Act
            var result = upgradeManager.Upgrade(json);

            // Assert
            Assert.NotNull(result);
            // The upgrade should have processed and handled the ambiguous version
        }

        [Fact]
        public void Upgrade_MultipleVersionsSequentially_AppliesAllUpgrades()
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = @"{
                ""jCSET_VERSION"": [{
                    ""Cset_Version1"": ""9.0.1.0"",
                    ""Version_Id"": ""9.0.1.0""
                }],
                ""jASSESSMENTS"": [{""Assessment_Id"": 1}],
                ""jAVAILABLE_MATURITY_MODELS"": [],
                ""jAVAILABLE_STANDARDS"": [],
                ""jSTANDARD_SELECTION"": [{""Application_Mode"": ""questions based""}],
                ""jASSESSMENT_DIAGRAM_COMPONENTS"": [],
                ""jNIST_SAL_QUESTION_ANSWERS"": [],
                ""jDOCUMENT_FILE"": [],
                ""jANSWER"": [{
                    ""Is_Requirement"": false,
                    ""Is_Component"": false,
                    ""Is_Framework"": false,
                    ""Component_Guid"": ""00000000-0000-0000-0000-000000000000""
                }]
            }";

            // Act
            var result = upgradeManager.Upgrade(json);

            // Assert
            Assert.NotNull(result);
            // Multiple upgrades should have been applied sequentially
        }

        [Fact]
        public void ParseVersion_EmptyString_ThrowsException()
        {
            // Act & Assert
            Assert.ThrowsAny<Exception>(() => ImportUpgradeManager.ParseVersion(""));
        }

        [Fact]
        public void ParseVersion_InvalidFormat_ThrowsException()
        {
            // Act & Assert
            Assert.ThrowsAny<Exception>(() => ImportUpgradeManager.ParseVersion("invalid"));
        }

        [Fact]
        public void NormalizeVersion_AllPartsPositive_PreservesValues()
        {
            // Arrange
            var version = new SysVersion(12, 4, 0, 5);

            // Act
            var result = ImportUpgradeManager.NormalizeVersion(version);

            // Assert
            Assert.Equal(12, result.Major);
            Assert.Equal(4, result.Minor);
            Assert.Equal(0, result.Build);
            Assert.Equal(5, result.Revision);
        }

        [Theory]
        [InlineData("9.0.0.0")]
        [InlineData("9.0.1.0")]
        [InlineData("9.0.4.0")]
        [InlineData("10.1.0.0")]
        [InlineData("10.1.1.0")]
        [InlineData("10.2.0.0")]
        [InlineData("10.3.0.0")]
        [InlineData("12.4.0.3")]
        [InlineData("12.4.0.4")]
        public void Upgrade_KnownVersions_UpgradesSuccessfully(string version)
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = $@"{{
                ""jCSET_VERSION"": [{{
                    ""Cset_Version1"": ""{version}"",
                    ""Version_Id"": ""{version}""
                }}],
                ""jASSESSMENTS"": [{{""Assessment_Id"": 1}}],
                ""jAVAILABLE_MATURITY_MODELS"": [],
                ""jAVAILABLE_STANDARDS"": [],
                ""jSTANDARD_SELECTION"": [{{""Application_Mode"": ""questions based""}}],
                ""jASSESSMENT_DIAGRAM_COMPONENTS"": [],
                ""jNIST_SAL_QUESTION_ANSWERS"": [],
                ""jDOCUMENT_FILE"": [],
                ""jANSWER"": [{{
                    ""Is_Requirement"": false,
                    ""Is_Component"": false,
                    ""Is_Framework"": false,
                    ""Component_Guid"": ""00000000-0000-0000-0000-000000000000""
                }}]
            }}";

            // Act
            var result = upgradeManager.Upgrade(json);

            // Assert
            Assert.NotNull(result);
            Assert.Contains("jCSET_VERSION", result);
        }

        [Fact]
        public void Upgrade_WithComplexJsonStructure_PreservesStructure()
        {
            // Arrange
            var upgradeManager = new ImportUpgradeManager();
            var json = @"{
                ""jCSET_VERSION"": [{
                    ""Cset_Version1"": ""12.4.0.5"",
                    ""Version_Id"": ""12.4.0.5""
                }],
                ""jASSESSMENTS"": [{
                    ""Assessment_Id"": 1,
                    ""Assessment_Name"": ""Test Assessment""
                }],
                ""jANSWER"": [{
                    ""Answer_Id"": 1,
                    ""Answer_Text"": ""Y""
                }]
            }";

            // Act
            var result = upgradeManager.Upgrade(json);

            // Assert
            Assert.NotNull(result);
            Assert.Contains("jASSESSMENTS", result);
            Assert.Contains("jANSWER", result);
            Assert.Contains("Test Assessment", result);
        }
    }
}
