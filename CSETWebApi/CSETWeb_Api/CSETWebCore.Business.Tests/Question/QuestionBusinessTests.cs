////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Question
{
    /// <summary>
    /// Unit tests for QuestionBusiness class.
    /// Tests question retrieval, answer storage, subcategory answers, and question list building.
    /// </summary>
    public class QuestionBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<ITokenManager> _mockTokenManager;
        private readonly Mock<IDocumentBusiness> _mockDocumentBusiness;
        private readonly Mock<IHtmlFromXamlConverter> _mockHtmlConverter;
        private readonly Mock<IQuestionRequirementManager> _mockQuestionRequirement;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly QuestionBusiness _questionBusiness;

        public QuestionBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockTokenManager = new Mock<ITokenManager>();
            _mockDocumentBusiness = new Mock<IDocumentBusiness>();
            _mockHtmlConverter = new Mock<IHtmlFromXamlConverter>();
            _mockQuestionRequirement = new Mock<IQuestionRequirementManager>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();

            _questionBusiness = new QuestionBusiness(
                _mockTokenManager.Object,
                _mockDocumentBusiness.Object,
                _mockHtmlConverter.Object,
                _mockQuestionRequirement.Object,
                _mockAssessmentUtil.Object,
                _mockContext.Object
            );
        }

        [Fact]
        public void SetQuestionAssessmentId_InitializesManager()
        {
            // Arrange
            var assessmentId = 1;
            _mockQuestionRequirement.Setup(q => q.InitializeManager(It.IsAny<int>()));

            // Act
            _questionBusiness.SetQuestionAssessmentId(assessmentId);

            // Assert
            _mockQuestionRequirement.Verify(q => q.InitializeManager(assessmentId), Times.Once);
        }

        [Fact]
        public void StoreAnswer_CreatesNewAnswer_WhenAnswerDoesNotExist()
        {
            // Arrange
            var assessmentId = 1;
            var questionId = 100;
            var answer = new Answer
            {
                QuestionId = questionId,
                AnswerText = "Y",
                QuestionType = "Question",
                QuestionNumber = "1",
                Comment = "Test comment"
            };

            var questions = new List<NEW_QUESTION>
            {
                new NEW_QUESTION { Question_Id = questionId, Simple_Question = "Test question?" }
            };

            var answers = new List<ANSWER>();
            var mockQuestionSet = CreateMockDbSet(questions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(CreateMockDbSet(new List<NEW_REQUIREMENT>()).Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _questionBusiness.StoreAnswer(answer);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(questionId, result.QuestionId);
            Assert.Equal("Y", result.AnswerText);
            mockAnswerSet.Verify(m => m.Update(It.IsAny<ANSWER>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void StoreAnswer_UpdatesExistingAnswer_WhenAnswerExists()
        {
            // Arrange
            var assessmentId = 1;
            var questionId = 100;
            var answerId = 50;

            var existingAnswer = new ANSWER
            {
                Answer_Id = answerId,
                Assessment_Id = assessmentId,
                Question_Or_Requirement_Id = questionId,
                Question_Type = "Question",
                Answer_Text = "N",
                Component_Guid = Guid.Empty
            };

            var answer = new Answer
            {
                QuestionId = questionId,
                AnswerText = "Y",
                QuestionType = "Question",
                QuestionNumber = "1",
                Comment = "Updated comment",
                MarkForReview = true
            };

            var questions = new List<NEW_QUESTION>
            {
                new NEW_QUESTION { Question_Id = questionId, Simple_Question = "Test question?" }
            };

            var answers = new List<ANSWER> { existingAnswer };
            var mockQuestionSet = CreateMockDbSet(questions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(CreateMockDbSet(new List<NEW_REQUIREMENT>()).Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _questionBusiness.StoreAnswer(answer);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Y", result.AnswerText);
            mockAnswerSet.Verify(m => m.Update(It.IsAny<ANSWER>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void StoreAnswer_DefaultsToUnanswered_WhenAnswerTextIsNull()
        {
            // Arrange
            var assessmentId = 1;
            var questionId = 100;
            var answer = new Answer
            {
                QuestionId = questionId,
                AnswerText = null,
                QuestionType = "Question",
                QuestionNumber = "1"
            };

            var questions = new List<NEW_QUESTION>
            {
                new NEW_QUESTION { Question_Id = questionId, Simple_Question = "Test question?" }
            };

            var answers = new List<ANSWER>();
            var mockQuestionSet = CreateMockDbSet(questions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(CreateMockDbSet(new List<NEW_REQUIREMENT>()).Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _questionBusiness.StoreAnswer(answer);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("U", result.AnswerText);
        }

        [Fact]
        public void StoreAnswer_ThrowsException_WhenQuestionDoesNotExist()
        {
            // Arrange
            var assessmentId = 1;
            var answer = new Answer
            {
                QuestionId = 999,
                AnswerText = "Y",
                QuestionType = "Question",
                QuestionNumber = "1"
            };

            var mockQuestionSet = CreateMockDbSet(new List<NEW_QUESTION>());
            var mockRequirementSet = CreateMockDbSet(new List<NEW_REQUIREMENT>());

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(mockRequirementSet.Object);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act & Assert
            var exception = Assert.Throws<Exception>(() => _questionBusiness.StoreAnswer(answer));
            Assert.Contains("Unknown question or requirement ID", exception.Message);
        }

        [Fact]
        public void StoreAnswer_HandlesComponentGuid_WhenProvided()
        {
            // Arrange
            var assessmentId = 1;
            var questionId = 100;
            var componentGuid = Guid.NewGuid();
            var answer = new Answer
            {
                QuestionId = questionId,
                AnswerText = "Y",
                QuestionType = "Component",
                QuestionNumber = "1",
                ComponentGuid = componentGuid
            };

            var questions = new List<NEW_QUESTION>
            {
                new NEW_QUESTION { Question_Id = questionId, Simple_Question = "Test question?" }
            };

            var answers = new List<ANSWER>();
            var mockQuestionSet = CreateMockDbSet(questions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(CreateMockDbSet(new List<NEW_REQUIREMENT>()).Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _questionBusiness.StoreAnswer(answer);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(componentGuid, result.ComponentGuid);
        }

        [Fact]
        public void StoreSubcategoryAnswers_DoesNothing_WhenAnswerBlockIsNull()
        {
            // Arrange
            SubCategoryAnswers? nullBlock = null;

            // Act
            _questionBusiness.StoreSubcategoryAnswers(nullBlock);

            // Assert
            _mockContext.Verify(c => c.SaveChanges(), Times.Never);
        }

        [Fact]
        public void StoreSubcategoryAnswers_CreatesNewSubCategoryAnswer_WhenNotExists()
        {
            // Arrange
            var assessmentId = 1;
            var groupHeadingId = 10;
            var subCategoryId = 20;
            var headingPairId = 30;

            var subCatAnswerBlock = new SubCategoryAnswers
            {
                GroupHeadingId = groupHeadingId,
                SubCategoryId = subCategoryId,
                SubCategoryAnswer = "Y",
                Answers = new List<Answer>()
            };

            var usch = new UNIVERSAL_SUB_CATEGORY_HEADINGS
            {
                Question_Group_Heading_Id = groupHeadingId,
                Universal_Sub_Category_Id = subCategoryId,
                Heading_Pair_Id = headingPairId
            };

            var uschList = new List<UNIVERSAL_SUB_CATEGORY_HEADINGS> { usch };
            var subCatAnswers = new List<SUB_CATEGORY_ANSWERS>();

            var mockUschSet = CreateMockDbSet(uschList);
            var mockSubCatAnswerSet = CreateMockDbSet(subCatAnswers);

            _mockContext.Setup(c => c.UNIVERSAL_SUB_CATEGORY_HEADINGS).Returns(mockUschSet.Object);
            _mockContext.Setup(c => c.SUB_CATEGORY_ANSWERS).Returns(mockSubCatAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockQuestionRequirement.Setup(q => q.AssessmentId).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            _questionBusiness.StoreSubcategoryAnswers(subCatAnswerBlock);

            // Assert
            mockSubCatAnswerSet.Verify(m => m.Add(It.Is<SUB_CATEGORY_ANSWERS>(
                sca => sca.Assessment_Id == assessmentId && sca.Answer_Text == "Y"
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void QuestionCountInSubGroup_ReturnsCorrectCount()
        {
            // Arrange
            var modelId = 5;
            var subGroup = "Access Control";
            var questions = new List<MATURITY_QUESTIONS>
            {
                new MATURITY_QUESTIONS { Mat_Question_Id = 1, Maturity_Model_Id = modelId, Sub_Category = subGroup },
                new MATURITY_QUESTIONS { Mat_Question_Id = 2, Maturity_Model_Id = modelId, Sub_Category = subGroup },
                new MATURITY_QUESTIONS { Mat_Question_Id = 3, Maturity_Model_Id = 6, Sub_Category = subGroup }
            };

            var mockQuestionSet = CreateMockDbSet(questions);
            _mockContext.Setup(c => c.MATURITY_QUESTIONS).Returns(mockQuestionSet.Object);

            // Act
            var result = _questionBusiness.QuestionCountInSubGroup(subGroup, modelId);

            // Assert
            Assert.Equal(2, result);
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
