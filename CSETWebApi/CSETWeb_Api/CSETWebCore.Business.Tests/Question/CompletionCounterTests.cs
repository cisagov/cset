////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Question
{
    /// <summary>
    /// Unit tests for CompletionCounter class.
    /// Tests question completion counting for standards-based, maturity, and component assessments.
    /// </summary>
    public class CompletionCounterTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly CompletionCounter _completionCounter;

        public CompletionCounterTests()
        {
            _mockContext = new Mock<CSETContext>();
            _completionCounter = new CompletionCounter(_mockContext.Object);
        }

        [Fact]
        public void GetAssessmentsCompletionForUser_ReturnsEmptyList_WhenNoAssessments()
        {
            // Arrange
            var userId = 1;
            var assessmentContacts = new List<ASSESSMENT_CONTACTS>();
            var assessments = new List<ASSESSMENTS>();

            var mockContactSet = CreateMockDbSet(assessmentContacts);
            var mockAssessmentSet = CreateMockDbSet(assessments);

            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _completionCounter.GetAssessmentsCompletionForUser(userId);

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        [Fact]
        public void GetAssessmentsCompletionForUser_ReturnsCompletionCounts_WhenAssessmentsExist()
        {
            // Arrange
            var userId = 1;
            var assessmentId = 10;

            var assessment = new ASSESSMENTS
            {
                Assessment_Id = assessmentId,
                CompletedQuestionCount = 5,
                TotalQuestionCount = 10
            };

            var assessmentContact = new ASSESSMENT_CONTACTS
            {
                UserId = userId,
                Assessment_Id = assessmentId
            };

            var assessmentContacts = new List<ASSESSMENT_CONTACTS> { assessmentContact };
            var assessments = new List<ASSESSMENTS> { assessment };

            var mockContactSet = CreateMockDbSet(assessmentContacts);
            var mockAssessmentSet = CreateMockDbSet(assessments);

            _mockContext.Setup(c => c.ASSESSMENT_CONTACTS).Returns(mockContactSet.Object);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _completionCounter.GetAssessmentsCompletionForUser(userId);

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal(assessmentId, result[0].AssessmentId);
            Assert.Equal(5, result[0].CompletedCount);
            Assert.Equal(10, result[0].TotalMaturityQuestionsCount);
        }

        [Fact]
        public void GetAssessmentsCompletionForAccessKey_ReturnsCompletionCounts()
        {
            // Arrange
            var accessKey = "test-key-123";
            var assessmentId = 10;

            var assessment = new ASSESSMENTS
            {
                Assessment_Id = assessmentId,
                CompletedQuestionCount = 3,
                TotalQuestionCount = 7
            };

            var accessKeyAssessment = new ACCESS_KEY_ASSESSMENT
            {
                AccessKey = accessKey,
                Assessment_Id = assessmentId
            };

            var accessKeyAssessments = new List<ACCESS_KEY_ASSESSMENT> { accessKeyAssessment };
            var assessments = new List<ASSESSMENTS> { assessment };

            var mockAccessKeySet = CreateMockDbSet(accessKeyAssessments);
            var mockAssessmentSet = CreateMockDbSet(assessments);

            _mockContext.Setup(c => c.ACCESS_KEY_ASSESSMENT).Returns(mockAccessKeySet.Object);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _completionCounter.GetAssessmentsCompletionForAccessKey(accessKey);

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal(assessmentId, result[0].AssessmentId);
            Assert.Equal(3, result[0].CompletedCount);
        }

        [Fact]
        public void Count_ReturnsNull_WhenAssessmentDoesNotExist()
        {
            // Arrange
            var assessmentId = 999;
            var assessments = new List<ASSESSMENTS>();
            var mockAssessmentSet = CreateMockDbSet(assessments);

            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _completionCounter.Count(assessmentId);

            // Assert
            Assert.Null(result);
        }

        [Fact]
        public void Count_CountsMaturityQuestions_WhenUseMaturityIsTrue()
        {
            // Arrange
            var assessmentId = 1;
            var modelId = 5;

            var assessment = new ASSESSMENTS
            {
                Assessment_Id = assessmentId,
                UseMaturity = true,
                UseStandard = false,
                UseDiagram = false
            };

            var availableModel = new AVAILABLE_MATURITY_MODELS
            {
                Assessment_Id = assessmentId,
                model_id = modelId
            };

            var maturityModel = new MATURITY_MODELS
            {
                Maturity_Model_Id = modelId
            };

            var maturityQuestion = new MATURITY_QUESTIONS
            {
                Mat_Question_Id = 1,
                Maturity_Model_Id = modelId,
                Is_Answerable = true
            };

            var answer = new ANSWER
            {
                Assessment_Id = assessmentId,
                Question_Or_Requirement_Id = 1,
                Question_Type = "Maturity",
                Answer_Text = "Y"
            };

            var assessments = new List<ASSESSMENTS> { assessment };
            var availableModels = new List<AVAILABLE_MATURITY_MODELS> { availableModel };
            var maturityModels = new List<MATURITY_MODELS> { maturityModel };
            var maturityQuestions = new List<MATURITY_QUESTIONS> { maturityQuestion };
            var answers = new List<ANSWER> { answer };

            var mockAssessmentSet = CreateMockDbSet(assessments);
            var mockAvailableModelSet = CreateMockDbSet(availableModels);
            var mockMaturityModelSet = CreateMockDbSet(maturityModels);
            var mockMaturityQuestionSet = CreateMockDbSet(maturityQuestions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);
            _mockContext.Setup(c => c.AVAILABLE_MATURITY_MODELS).Returns(mockAvailableModelSet.Object);
            _mockContext.Setup(c => c.MATURITY_MODELS).Returns(mockMaturityModelSet.Object);
            _mockContext.Setup(c => c.MATURITY_QUESTIONS).Returns(mockMaturityQuestionSet.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.ASSESSMENT_SELECTED_LEVELS).Returns(CreateMockDbSet(new List<ASSESSMENT_SELECTED_LEVELS>()).Object);
            _mockContext.Setup(c => c.MATURITY_LEVELS).Returns(CreateMockDbSet(new List<MATURITY_LEVELS>()).Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            var result = _completionCounter.Count(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(assessmentId, result.AssessmentId);
            Assert.NotNull(result.TotalMaturityQuestionsCount);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
        }

        [Fact]
        public void DetermineInScopeModels_ReturnsDefaultModels_WhenNoSpecialCases()
        {
            // Arrange
            var assessmentId = 1;
            var modelId = 10;

            var availableModel = new AVAILABLE_MATURITY_MODELS
            {
                Assessment_Id = assessmentId,
                model_id = modelId
            };

            var maturityModel = new MATURITY_MODELS
            {
                Maturity_Model_Id = modelId
            };

            var assessment = new ASSESSMENTS
            {
                Assessment_Id = assessmentId,
                UseMaturity = true
            };

            var availableModels = new List<AVAILABLE_MATURITY_MODELS> { availableModel };
            var maturityModels = new List<MATURITY_MODELS> { maturityModel };
            var assessments = new List<ASSESSMENTS> { assessment };

            var mockAvailableModelSet = CreateMockDbSet(availableModels);
            var mockMaturityModelSet = CreateMockDbSet(maturityModels);
            var mockAssessmentSet = CreateMockDbSet(assessments);

            _mockContext.Setup(c => c.AVAILABLE_MATURITY_MODELS).Returns(mockAvailableModelSet.Object);
            _mockContext.Setup(c => c.MATURITY_MODELS).Returns(mockMaturityModelSet.Object);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _completionCounter.DetermineInScopeModels(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Contains(modelId, result);
        }

        [Fact]
        public void DetermineInScopeModels_ReturnsCrePlusModels_WhenCreModelIsSelected()
        {
            // Arrange
            var assessmentId = 1;
            var creModelId = 22; // Model_CRE constant (corrected from 21)

            var availableModel = new AVAILABLE_MATURITY_MODELS
            {
                Assessment_Id = assessmentId,
                model_id = creModelId
            };

            var maturityModel = new MATURITY_MODELS
            {
                Maturity_Model_Id = creModelId
            };

            var assessment = new ASSESSMENTS
            {
                Assessment_Id = assessmentId,
                UseMaturity = true
            };

            var maturityQuestions = new List<MATURITY_QUESTIONS>
            {
                new MATURITY_QUESTIONS { Mat_Question_Id = 1, Maturity_Model_Id = 22, Is_Answerable = true },
                new MATURITY_QUESTIONS { Mat_Question_Id = 2, Maturity_Model_Id = 23, Is_Answerable = true },
                new MATURITY_QUESTIONS { Mat_Question_Id = 3, Maturity_Model_Id = 24, Is_Answerable = true }
            };

            var availableModels = new List<AVAILABLE_MATURITY_MODELS> { availableModel };
            var maturityModels = new List<MATURITY_MODELS> { maturityModel };
            var assessments = new List<ASSESSMENTS> { assessment };

            var mockAvailableModelSet = CreateMockDbSet(availableModels);
            var mockMaturityModelSet = CreateMockDbSet(maturityModels);
            var mockAssessmentSet = CreateMockDbSet(assessments);
            var mockMaturityQuestionSet = CreateMockDbSet(maturityQuestions);

            _mockContext.Setup(c => c.AVAILABLE_MATURITY_MODELS).Returns(mockAvailableModelSet.Object);
            _mockContext.Setup(c => c.MATURITY_MODELS).Returns(mockMaturityModelSet.Object);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);
            _mockContext.Setup(c => c.MATURITY_QUESTIONS).Returns(mockMaturityQuestionSet.Object);

            // Act
            var result = _completionCounter.DetermineInScopeModels(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Contains(22, result); // Model_CRE
            Assert.Contains(23, result); // Model_CRE_OD
            Assert.Contains(24, result); // Model_CRE_MIL
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
