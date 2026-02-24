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
    /// Unit tests for NistSalBusiness class.
    /// Tests NIST information type management, question handling, and SAL calculation.
    ///
    /// NOTE: Some methods in NistSalBusiness are difficult to test in isolation due to:
    /// - Direct ExecuteSqlRaw calls for CreateInitialList() - requires integration testing
    /// - Complex TinyMapper usage - requires careful mock setup
    /// - TranslationOverlay dependency - language-specific translation logic
    ///
    /// This test suite focuses on testable business logic and data flow.
    /// </summary>
    public class NistSalBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly Mock<ITokenManager> _mockTokenManager;
        private readonly NistSalBusiness _nistSalBusiness;

        public NistSalBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
            _mockTokenManager = new Mock<ITokenManager>();

            // Default to English language
            _mockTokenManager.Setup(t => t.GetCurrentLanguage()).Returns("en");

            // Mock the Database facade to handle ExecuteSqlRaw calls
            var mockDatabase = new Mock<Microsoft.EntityFrameworkCore.Infrastructure.DatabaseFacade>(_mockContext.Object);
            _mockContext.Setup(c => c.Database).Returns(mockDatabase.Object);

            // Setup required DbSets for LevelManager (used in CalculateOveralls and GetInformationTypes)
            _mockContext.Setup(c => c.PARAMETER_VALUES).Returns(CreateMockDbSet(new List<PARAMETER_VALUES>()).Object);
            _mockContext.Setup(c => c.ASSESSMENT_SELECTED_LEVELS).Returns(CreateMockDbSet(new List<ASSESSMENT_SELECTED_LEVELS>()).Object);

            _nistSalBusiness = new NistSalBusiness(
                _mockContext.Object,
                _mockAssessmentUtil.Object,
                _mockTokenManager.Object
            );
        }

        [Fact]
        public void GetNistQuestions_ReturnsExistingAnswers_WhenAnswersExist()
        {
            // Arrange
            var assessmentId = 1;

            var questions = new List<NIST_SAL_QUESTIONS>
            {
                new NIST_SAL_QUESTIONS
                {
                    Question_Id = 1,
                    Question_Number = 1,
                    Question_Text = "Question 1"
                },
                new NIST_SAL_QUESTIONS
                {
                    Question_Id = 2,
                    Question_Number = 2,
                    Question_Text = "Question 2"
                }
            };

            var answers = new List<NIST_SAL_QUESTION_ANSWERS>
            {
                new NIST_SAL_QUESTION_ANSWERS
                {
                    Assessment_Id = assessmentId,
                    Question_Id = 1,
                    Question_Answer = "Yes"
                },
                new NIST_SAL_QUESTION_ANSWERS
                {
                    Assessment_Id = assessmentId,
                    Question_Id = 2,
                    Question_Answer = "No"
                }
            };

            var mockQuestionsSet = CreateMockDbSet(questions);
            var mockAnswersSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockAnswersSet.Object);

            // Act
            var result = _nistSalBusiness.GetNistQuestions(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.Count);
            Assert.Equal("Yes", result[0].Question_Answer);
            Assert.Equal("No", result[1].Question_Answer);
            Assert.Equal("Question 1", result[0].Question_Text);
        }

        [Fact]
        public void GetNistQuestions_CreatesDefaultAnswers_WhenNoAnswersExist()
        {
            // Arrange
            var assessmentId = 1;

            var questions = new List<NIST_SAL_QUESTIONS>
            {
                new NIST_SAL_QUESTIONS
                {
                    Question_Id = 1,
                    Question_Number = 1,
                    Question_Text = "Question 1"
                }
            };

            var answers = new List<NIST_SAL_QUESTION_ANSWERS>();

            var mockQuestionsSet = CreateMockDbSet(questions);
            var mockAnswersSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockAnswersSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            var result = _nistSalBusiness.GetNistQuestions(assessmentId);

            // Assert
            Assert.NotNull(result);
            mockAnswersSet.Verify(m => m.Add(It.Is<NIST_SAL_QUESTION_ANSWERS>(
                a => a.Assessment_Id == assessmentId &&
                     a.Question_Id == 1 &&
                     a.Question_Answer == "No"
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void GetNistQuestions_DefaultsToNo_ForAllQuestions()
        {
            // Arrange
            var assessmentId = 1;

            var questions = new List<NIST_SAL_QUESTIONS>
            {
                new NIST_SAL_QUESTIONS { Question_Id = 1, Question_Number = 1, Question_Text = "Q1" },
                new NIST_SAL_QUESTIONS { Question_Id = 2, Question_Number = 2, Question_Text = "Q2" },
                new NIST_SAL_QUESTIONS { Question_Id = 3, Question_Number = 3, Question_Text = "Q3" }
            };

            var answers = new List<NIST_SAL_QUESTION_ANSWERS>();

            var mockQuestionsSet = CreateMockDbSet(questions);
            var mockAnswersSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockAnswersSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            var result = _nistSalBusiness.GetNistQuestions(assessmentId);

            // Assert
            mockAnswersSet.Verify(m => m.Add(It.Is<NIST_SAL_QUESTION_ANSWERS>(
                a => a.Question_Answer == "No"
            )), Times.Exactly(3));
        }

        [Fact]
        public void SaveNistQuestions_UpdatesExistingAnswer()
        {
            // Arrange
            var assessmentId = 1;
            var questionId = 1;

            var existingAnswer = new NIST_SAL_QUESTION_ANSWERS
            {
                Assessment_Id = assessmentId,
                Question_Id = questionId,
                Question_Answer = "No"
            };

            var answerToSave = new NistQuestionsAnswers
            {
                Assessment_Id = assessmentId,
                Question_Id = questionId,
                Question_Answer = "Yes",
                Question_Number = 1,
                Question_Text = "Test Question"
            };

            var answers = new List<NIST_SAL_QUESTION_ANSWERS> { existingAnswer };
            var mockAnswersSet = CreateMockDbSet(answers);

            var infoTypes = new List<NIST_SAL_INFO_TYPES>();
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            var nistQuestions = new List<NIST_SAL_QUESTIONS>();
            var mockNistQuestionsSet = CreateMockDbSet(nistQuestions);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            var paramValues = new List<PARAMETER_VALUES>();
            var mockParamValuesSet = CreateMockDbSet(paramValues);

            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockAnswersSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockNistQuestionsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.PARAMETER_VALUES).Returns(mockParamValuesSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            var result = _nistSalBusiness.SaveNistQuestions(assessmentId, answerToSave);

            // Assert
            Assert.Equal("Yes", existingAnswer.Question_Answer);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
            Assert.NotNull(result);
        }

        [Fact]
        public void SaveNistQuestions_ThrowsException_WhenQuestionNotFound()
        {
            // Arrange
            var assessmentId = 1;
            var answerToSave = new NistQuestionsAnswers
            {
                Assessment_Id = assessmentId,
                Question_Id = 999,
                Question_Answer = "Yes",
                Question_Number = 999,
                Question_Text = "Non-existent Question"
            };

            var answers = new List<NIST_SAL_QUESTION_ANSWERS>();
            var mockAnswersSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockAnswersSet.Object);

            // Act & Assert
            var exception = Assert.Throws<ApplicationException>(() =>
                _nistSalBusiness.SaveNistQuestions(assessmentId, answerToSave));
            Assert.Contains("Question 999 could not be found for assessment 1", exception.Message);
        }

        [Fact]
        public void CalculatedNist_ReturnsLowDefaults_WithNoData()
        {
            // Arrange
            var assessmentId = 1;

            var infoTypes = new List<NIST_SAL_INFO_TYPES>();
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            var questionAnswers = new List<NIST_SAL_QUESTION_ANSWERS>();
            var mockQuestionsSet = CreateMockDbSet(questionAnswers);

            var nistQuestions = new List<NIST_SAL_QUESTIONS>();
            var mockNistQuestionsSet = CreateMockDbSet(nistQuestions);

            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTION_ANSWERS).Returns(mockQuestionsSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_QUESTIONS).Returns(mockNistQuestionsSet.Object);

            // Act
            var result = _nistSalBusiness.CalculatedNist(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Low", result.Selected_Sal_Level);
            Assert.Equal("Low", result.CLevel);
            Assert.Equal("Low", result.ILevel);
            Assert.Equal("Low", result.ALevel);
        }

        [Fact]
        public void CalculatedNist_ReturnsCorrectLevels_WithInfoTypes()
        {
            // Arrange
            var assessmentId = 1;

            var infoTypes = new List<NIST_SAL_INFO_TYPES>
            {
                new NIST_SAL_INFO_TYPES
                {
                    Assessment_Id = assessmentId,
                    Type_Value = "Test Type",
                    Selected = true,
                    Confidentiality_Value = "Moderate",
                    Integrity_Value = "High",
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
            var result = _nistSalBusiness.CalculatedNist(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("High", result.Selected_Sal_Level); // Overall is highest
            Assert.Equal("Moderate", result.CLevel);
            Assert.Equal("High", result.ILevel);
            Assert.Equal("Low", result.ALevel);
        }

        [Fact]
        public void GetSpecialFactors_ReturnsNonNullObject()
        {
            // Arrange
            var assessmentId = 1;

            var ciaJustifications = new List<CNSS_CIA_JUSTIFICATIONS>();
            var mockCiaSet = CreateMockDbSet(ciaJustifications);

            _mockContext.Setup(c => c.CNSS_CIA_JUSTIFICATIONS).Returns(mockCiaSet.Object);

            // Act
            var result = _nistSalBusiness.GetSpecialFactors(assessmentId);

            // Assert
            Assert.NotNull(result);
        }

        [Fact(Skip = "Requires database access for ExecuteSqlRaw - should be an integration test")]
        public void GetInformationTypes_ReturnsEmptyList_WhenNoTypesSelected()
        {
            // Arrange
            var assessmentId = 1;

            // Setup for CreateInitialList - it checks STANDARD_SELECTION first
            var standardSelections = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelections);

            var infoTypes = new List<NIST_SAL_INFO_TYPES>();
            var mockInfoTypesSet = CreateMockDbSet(infoTypes);

            var defaults = new List<NIST_SAL_INFO_TYPES_DEFAULTS>();
            var mockDefaultsSet = CreateMockDbSet(defaults);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES).Returns(mockInfoTypesSet.Object);
            _mockContext.Setup(c => c.NIST_SAL_INFO_TYPES_DEFAULTS).Returns(mockDefaultsSet.Object);

            // Act
            var result = _nistSalBusiness.GetInformationTypes(assessmentId);

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

            // Setup Add to actually add to the list
            mockSet.Setup(m => m.Add(It.IsAny<T>())).Callback<T>(data.Add);

            return mockSet;
        }

        public void Dispose()
        {
            // Cleanup if needed
        }
    }
}
