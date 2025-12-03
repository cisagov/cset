using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Sal
{
    /// <summary>
    /// Unit tests for NistProcessingLogic class.
    /// Tests NIST SAL calculation logic, level increment operations, and highest level determination.
    /// </summary>
    public class NistProcessingLogicTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly NistProcessingLogic _nistLogic;

        public NistProcessingLogicTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
            _nistLogic = new NistProcessingLogic(_mockContext.Object, _mockAssessmentUtil.Object);
        }

        [Fact]
        public void GetWeightPair_ReturnsCorrectSALForLow()
        {
            // Act
            var result = _nistLogic.GetWeightPair("Low");

            // Assert
            Assert.NotNull(result);
            Assert.Equal(1, result.SALValue);
            Assert.Equal("Low", result.SALName);
        }

        [Fact]
        public void GetWeightPair_ReturnsCorrectSALForModerate()
        {
            // Act
            var result = _nistLogic.GetWeightPair("Moderate");

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.SALValue);
            Assert.Equal("Moderate", result.SALName);
        }

        [Fact]
        public void GetWeightPair_ReturnsCorrectSALForHigh()
        {
            // Act
            var result = _nistLogic.GetWeightPair("High");

            // Assert
            Assert.NotNull(result);
            Assert.Equal(3, result.SALValue);
            Assert.Equal("High", result.SALName);
        }

        [Fact]
        public void GetWeightPair_ReturnsCorrectSALForVeryHigh()
        {
            // Act
            var result = _nistLogic.GetWeightPair("Very High");

            // Assert
            Assert.NotNull(result);
            Assert.Equal(4, result.SALValue);
            Assert.Equal("Very High", result.SALName);
        }

        [Fact]
        public void GetWeightPair_IsCaseInsensitive()
        {
            // Act
            var result = _nistLogic.GetWeightPair("MODERATE");

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.SALValue);
            Assert.Equal("Moderate", result.SALName);
        }

        [Fact]
        public void GetHighestLevel_ReturnsConfidentiality_WhenItIsHighest()
        {
            // Arrange
            var currentHighest = _nistLogic.GetWeightPair("Low");
            var confidentiality = _nistLogic.GetWeightPair("High");
            var availability = _nistLogic.GetWeightPair("Moderate");
            var integrity = _nistLogic.GetWeightPair("Low");

            // Act
            var result = _nistLogic.GetHighestLevel(currentHighest, confidentiality, availability, integrity);

            // Assert
            Assert.Equal(3, result.SALValue);
            Assert.Equal("High", result.SALName);
        }

        [Fact]
        public void GetHighestLevel_ReturnsAvailability_WhenItIsHighest()
        {
            // Arrange
            var currentHighest = _nistLogic.GetWeightPair("Low");
            var confidentiality = _nistLogic.GetWeightPair("Low");
            var availability = _nistLogic.GetWeightPair("Very High");
            var integrity = _nistLogic.GetWeightPair("Moderate");

            // Act
            var result = _nistLogic.GetHighestLevel(currentHighest, confidentiality, availability, integrity);

            // Assert
            Assert.Equal(4, result.SALValue);
            Assert.Equal("Very High", result.SALName);
        }

        [Fact]
        public void GetHighestLevel_ReturnsIntegrity_WhenItIsHighest()
        {
            // Arrange
            var currentHighest = _nistLogic.GetWeightPair("Low");
            var confidentiality = _nistLogic.GetWeightPair("Low");
            var availability = _nistLogic.GetWeightPair("Low");
            var integrity = _nistLogic.GetWeightPair("Moderate");

            // Act
            var result = _nistLogic.GetHighestLevel(currentHighest, confidentiality, availability, integrity);

            // Assert
            Assert.Equal(2, result.SALValue);
            Assert.Equal("Moderate", result.SALName);
        }

        [Fact]
        public void GetHighestLevel_KeepsCurrentHighest_WhenAllAreLower()
        {
            // Arrange
            var currentHighest = _nistLogic.GetWeightPair("High");
            var confidentiality = _nistLogic.GetWeightPair("Low");
            var availability = _nistLogic.GetWeightPair("Low");
            var integrity = _nistLogic.GetWeightPair("Moderate");

            // Act
            var result = _nistLogic.GetHighestLevel(currentHighest, confidentiality, availability, integrity);

            // Assert
            Assert.Equal(3, result.SALValue);
            Assert.Equal("High", result.SALName);
        }

        [Fact]
        public void CalcLevels_CalculatesCorrectly_WithNoSelectedInfoTypes()
        {
            // Arrange
            var assessmentId = 1;

            var infoTypes = new List<NIST_SAL_INFO_TYPES>();
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            var questions = new List<NIST_SAL_QUESTION_ANSWERS>();
            var mockQuestionsSet = CreateMockDbSet(questions);

            var nistQuestions = new List<NIST_SAL_QUESTIONS>();
            var mockNistQuestionsSet = CreateMockDbSet(nistQuestions);

            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockNistQuestionsSet.Object);

            // Act
            _nistLogic.CalcLevels(assessmentId);

            // Assert
            Assert.Equal("Low", _nistLogic.HighestOverallNISTSALLevel.SALName);
            Assert.Equal("Low", _nistLogic.highestQuestionConfidentialityValue.SALName);
            Assert.Equal("Low", _nistLogic.highestQuestionAvailabilityValue.SALName);
            Assert.Equal("Low", _nistLogic.highestQuestionIntegrityValue.SALName);
        }

        [Fact]
        public void CalcLevels_UsesInfoTypes_WhenSelected()
        {
            // Arrange
            var assessmentId = 1;

            var infoTypes = new List<NIST_SAL_INFO_TYPES>
            {
                new NIST_SAL_INFO_TYPES
                {
                    Assessment_Id = assessmentId,
                    Type_Value = "Healthcare Information",
                    Selected = true,
                    Confidentiality_Value = "High",
                    Integrity_Value = "Moderate",
                    Availability_Value = "Low"
                }
            };
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            var questionAnswers = new List<NIST_SAL_QUESTION_ANSWERS>();
            var mockQuestionsSet = CreateMockDbSet(questionAnswers);

            var nistQuestions = new List<NIST_SAL_QUESTIONS>();
            var mockNistQuestionsSet = CreateMockDbSet(nistQuestions);

            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockNistQuestionsSet.Object);

            // Act
            _nistLogic.CalcLevels(assessmentId);

            // Assert
            Assert.Equal("High", _nistLogic.highestInfoTypeConfidentialityValue.SALName);
            Assert.Equal("Moderate", _nistLogic.highestInfoTypeIntegrityValue.SALName);
            Assert.Equal("Low", _nistLogic.highestInfoTypeAvailabilityValue.SALName);
            Assert.Equal("High", _nistLogic.HighestOverallNISTSALLevel.SALName);
        }

        [Fact]
        public void CalcLevels_IncrementsLevels_ForQuestion1YesAnswer()
        {
            // Arrange
            var assessmentId = 1;

            var infoTypes = new List<NIST_SAL_INFO_TYPES>
            {
                new NIST_SAL_INFO_TYPES
                {
                    Assessment_Id = assessmentId,
                    Type_Value = "Test Info",
                    Selected = true,
                    Confidentiality_Value = "Low",
                    Integrity_Value = "Low",
                    Availability_Value = "Low"
                }
            };
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            var questionAnswers = new List<NIST_SAL_QUESTION_ANSWERS>
            {
                new NIST_SAL_QUESTION_ANSWERS
                {
                    Assessment_Id = assessmentId,
                    Question_Id = 1,
                    Question_Answer = "Yes"
                }
            };
            var mockQuestionsSet = CreateMockDbSet(questionAnswers);

            var nistQuestions = new List<NIST_SAL_QUESTIONS>
            {
                new NIST_SAL_QUESTIONS
                {
                    Question_Id = 1,
                    Question_Number = 1,
                    Question_Text = "Test Question 1"
                }
            };
            var mockNistQuestionsSet = CreateMockDbSet(nistQuestions);

            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockNistQuestionsSet.Object);

            // Act
            _nistLogic.CalcLevels(assessmentId);

            // Assert - Question 1 affects C, A, and I
            Assert.Equal("Moderate", _nistLogic.highestQuestionConfidentialityValue.SALName);
            Assert.Equal("Moderate", _nistLogic.highestQuestionAvailabilityValue.SALName);
            Assert.Equal("Moderate", _nistLogic.highestQuestionIntegrityValue.SALName);
        }

        [Fact]
        public void CalcLevels_DoesNotIncrement_ForNoAnswer()
        {
            // Arrange
            var assessmentId = 1;

            var infoTypes = new List<NIST_SAL_INFO_TYPES>
            {
                new NIST_SAL_INFO_TYPES
                {
                    Assessment_Id = assessmentId,
                    Type_Value = "Test Info",
                    Selected = true,
                    Confidentiality_Value = "Low",
                    Integrity_Value = "Low",
                    Availability_Value = "Low"
                }
            };
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            var questionAnswers = new List<NIST_SAL_QUESTION_ANSWERS>
            {
                new NIST_SAL_QUESTION_ANSWERS
                {
                    Assessment_Id = assessmentId,
                    Question_Id = 1,
                    Question_Answer = "No"
                }
            };
            var mockQuestionsSet = CreateMockDbSet(questionAnswers);

            var nistQuestions = new List<NIST_SAL_QUESTIONS>
            {
                new NIST_SAL_QUESTIONS
                {
                    Question_Id = 1,
                    Question_Number = 1,
                    Question_Text = "Test Question 1"
                }
            };
            var mockNistQuestionsSet = CreateMockDbSet(nistQuestions);

            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockNistQuestionsSet.Object);

            // Act
            _nistLogic.CalcLevels(assessmentId);

            // Assert - No increment should occur
            Assert.Equal("Low", _nistLogic.highestQuestionConfidentialityValue.SALName);
            Assert.Equal("Low", _nistLogic.highestQuestionAvailabilityValue.SALName);
            Assert.Equal("Low", _nistLogic.highestQuestionIntegrityValue.SALName);
        }

        [Fact]
        public void CalcLevels_HandlesMultipleInfoTypes_SelectsHighest()
        {
            // Arrange
            var assessmentId = 1;

            var infoTypes = new List<NIST_SAL_INFO_TYPES>
            {
                new NIST_SAL_INFO_TYPES
                {
                    Assessment_Id = assessmentId,
                    Type_Value = "Type 1",
                    Selected = true,
                    Confidentiality_Value = "Low",
                    Integrity_Value = "Moderate",
                    Availability_Value = "Low"
                },
                new NIST_SAL_INFO_TYPES
                {
                    Assessment_Id = assessmentId,
                    Type_Value = "Type 2",
                    Selected = true,
                    Confidentiality_Value = "High",
                    Integrity_Value = "Low",
                    Availability_Value = "Moderate"
                }
            };
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            var questionAnswers = new List<NIST_SAL_QUESTION_ANSWERS>();
            var mockQuestionsSet = CreateMockDbSet(questionAnswers);

            var nistQuestions = new List<NIST_SAL_QUESTIONS>();
            var mockNistQuestionsSet = CreateMockDbSet(nistQuestions);

            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockNistQuestionsSet.Object);

            // Act
            _nistLogic.CalcLevels(assessmentId);

            // Assert - Should pick highest from each category
            Assert.Equal("High", _nistLogic.highestInfoTypeConfidentialityValue.SALName);
            Assert.Equal("Moderate", _nistLogic.highestInfoTypeIntegrityValue.SALName);
            Assert.Equal("Moderate", _nistLogic.highestInfoTypeAvailabilityValue.SALName);
            Assert.Equal("High", _nistLogic.HighestOverallNISTSALLevel.SALName);
        }

        [Fact]
        public void CalcLevels_CapsAtHigh_WhenMultipleIncrementsExceedMax()
        {
            // Arrange
            var assessmentId = 1;

            var infoTypes = new List<NIST_SAL_INFO_TYPES>
            {
                new NIST_SAL_INFO_TYPES
                {
                    Assessment_Id = assessmentId,
                    Type_Value = "Test Info",
                    Selected = true,
                    Confidentiality_Value = "Moderate",
                    Integrity_Value = "Moderate",
                    Availability_Value = "Moderate"
                }
            };
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            // Answer "Yes" to questions that increment all levels
            var questionAnswers = new List<NIST_SAL_QUESTION_ANSWERS>
            {
                new NIST_SAL_QUESTION_ANSWERS { Assessment_Id = assessmentId, Question_Id = 1, Question_Answer = "Yes" },
                new NIST_SAL_QUESTION_ANSWERS { Assessment_Id = assessmentId, Question_Id = 2, Question_Answer = "Yes" },
                new NIST_SAL_QUESTION_ANSWERS { Assessment_Id = assessmentId, Question_Id = 3, Question_Answer = "Yes" }
            };
            var mockQuestionsSet = CreateMockDbSet(questionAnswers);

            var nistQuestions = new List<NIST_SAL_QUESTIONS>
            {
                new NIST_SAL_QUESTIONS { Question_Id = 1, Question_Number = 1, Question_Text = "Q1" },
                new NIST_SAL_QUESTIONS { Question_Id = 2, Question_Number = 2, Question_Text = "Q2" },
                new NIST_SAL_QUESTIONS { Question_Id = 3, Question_Number = 3, Question_Text = "Q3" }
            };
            var mockNistQuestionsSet = CreateMockDbSet(nistQuestions);

            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockNistQuestionsSet.Object);

            // Act
            _nistLogic.CalcLevels(assessmentId);

            // Assert - Should cap at High (value 3), not exceed
            Assert.Equal("High", _nistLogic.highestQuestionConfidentialityValue.SALName);
            Assert.Equal(3, _nistLogic.highestQuestionConfidentialityValue.SALValue);
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
