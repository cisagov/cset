using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Question
{
    /// <summary>
    /// Unit tests for ComponentQuestionBusiness class.
    /// Tests component question retrieval, answer storage, and component GUID handling.
    /// </summary>
    public class ComponentQuestionBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly Mock<ITokenManager> _mockTokenManager;
        private readonly Mock<IQuestionRequirementManager> _mockQuestionRequirement;
        private readonly ComponentQuestionBusiness _componentQuestionBusiness;

        public ComponentQuestionBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
            _mockTokenManager = new Mock<ITokenManager>();
            _mockQuestionRequirement = new Mock<IQuestionRequirementManager>();

            // Setup required DbSets for LevelManager (used in GetOverrideListOnly)
            _mockContext.Setup(c => c.ASSESSMENT_SELECTED_LEVELS).Returns(CreateMockDbSet(new List<ASSESSMENT_SELECTED_LEVELS>()).Object);

            _componentQuestionBusiness = new ComponentQuestionBusiness(
                _mockContext.Object,
                _mockAssessmentUtil.Object,
                _mockTokenManager.Object,
                _mockQuestionRequirement.Object
            );
        }

        [Fact]
        public void StoreAnswer_CreatesNewComponentAnswer_WhenAnswerDoesNotExist()
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
                new NEW_QUESTION { Question_Id = questionId, Simple_Question = "Component question?" }
            };

            var answers = new List<ANSWER>();
            var mockQuestionSet = CreateMockDbSet(questions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _componentQuestionBusiness.StoreAnswer(answer);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(questionId, result.QuestionId);
            Assert.Equal("Y", result.AnswerText);
            Assert.Equal(componentGuid, result.ComponentGuid);
            mockAnswerSet.Verify(m => m.Add(It.IsAny<ANSWER>()), Times.Once);
            mockAnswerSet.Verify(m => m.Update(It.IsAny<ANSWER>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeast(2));
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(assessmentId), Times.Once);
        }

        [Fact]
        public void StoreAnswer_UpdatesExistingComponentAnswer_WhenAnswerExists()
        {
            // Arrange
            var assessmentId = 1;
            var questionId = 100;
            var componentGuid = Guid.NewGuid();
            var answerId = 50;

            var existingAnswer = new ANSWER
            {
                Answer_Id = answerId,
                Assessment_Id = assessmentId,
                Question_Or_Requirement_Id = questionId,
                Question_Type = "Component",
                Answer_Text = "N",
                Component_Guid = componentGuid,
                Is_Requirement = false,
                Is_Component = true
            };

            var answer = new Answer
            {
                QuestionId = questionId,
                AnswerText = "Y",
                QuestionType = "Component",
                QuestionNumber = "1",
                ComponentGuid = componentGuid,
                Comment = "Updated comment"
            };

            var questions = new List<NEW_QUESTION>
            {
                new NEW_QUESTION { Question_Id = questionId, Simple_Question = "Component question?" }
            };

            var answers = new List<ANSWER> { existingAnswer };
            var mockQuestionSet = CreateMockDbSet(questions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _componentQuestionBusiness.StoreAnswer(answer);

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
            var componentGuid = Guid.NewGuid();

            var answer = new Answer
            {
                QuestionId = questionId,
                AnswerText = null,
                QuestionType = "Component",
                QuestionNumber = "1",
                ComponentGuid = componentGuid
            };

            var questions = new List<NEW_QUESTION>
            {
                new NEW_QUESTION { Question_Id = questionId, Simple_Question = "Component question?" }
            };

            var answers = new List<ANSWER>();
            var mockQuestionSet = CreateMockDbSet(questions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _componentQuestionBusiness.StoreAnswer(answer);

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
                QuestionType = "Component",
                QuestionNumber = "1",
                ComponentGuid = Guid.NewGuid()
            };

            var mockQuestionSet = CreateMockDbSet(new List<NEW_QUESTION>());
            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act & Assert
            var exception = Assert.Throws<Exception>(() => _componentQuestionBusiness.StoreAnswer(answer));
            Assert.Contains("Unknown question or requirement ID", exception.Message);
        }

        [Fact]
        public void HandleGuid_CreatesAnswers_WhenShouldSaveIsTrue()
        {
            // Arrange
            var assessmentId = 1;
            var componentGuid = Guid.NewGuid();
            var componentSymbolId = 5;
            var questionId = 100;

            var component = new ASSESSMENT_DIAGRAM_COMPONENTS
            {
                Component_Guid = componentGuid,
                Component_Symbol_Id = componentSymbolId,
                Assessment_Id = assessmentId
            };

            var componentQuestion = new COMPONENT_QUESTIONS
            {
                Component_Symbol_Id = componentSymbolId,
                Question_Id = questionId
            };

            var components = new List<ASSESSMENT_DIAGRAM_COMPONENTS> { component };
            var componentQuestions = new List<COMPONENT_QUESTIONS> { componentQuestion };
            var answers = new List<ANSWER>();

            var mockComponentSet = CreateMockDbSet(components);
            var mockComponentQuestionSet = CreateMockDbSet(componentQuestions);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockComponentSet.Object);
            _mockContext.Setup(c => c.COMPONENT_QUESTIONS).Returns(mockComponentQuestionSet.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act
            _componentQuestionBusiness.HandleGuid(componentGuid, true);

            // Assert
            mockAnswerSet.Verify(m => m.Add(It.Is<ANSWER>(
                a => a.Component_Guid == componentGuid &&
                     a.Question_Type == "Component" &&
                     a.Is_Component == true &&
                     a.Is_Requirement == false
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void HandleGuid_RemovesAnswers_WhenShouldSaveIsFalse()
        {
            // Arrange
            var assessmentId = 1;
            var componentGuid = Guid.NewGuid();

            var answer1 = new ANSWER
            {
                Answer_Id = 1,
                Component_Guid = componentGuid,
                Assessment_Id = assessmentId
            };

            var answer2 = new ANSWER
            {
                Answer_Id = 2,
                Component_Guid = componentGuid,
                Assessment_Id = assessmentId
            };

            var answers = new List<ANSWER> { answer1, answer2 };
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act
            _componentQuestionBusiness.HandleGuid(componentGuid, false);

            // Assert
            mockAnswerSet.Verify(m => m.Remove(It.IsAny<ANSWER>()), Times.Exactly(2));
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void HandleGuid_ThrowsException_WhenComponentNotFound()
        {
            // Arrange
            var assessmentId = 1;
            var componentGuid = Guid.NewGuid();

            var components = new List<ASSESSMENT_DIAGRAM_COMPONENTS>();
            var mockComponentSet = CreateMockDbSet(components);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockComponentSet.Object);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act & Assert
            var exception = Assert.Throws<ApplicationException>(() => _componentQuestionBusiness.HandleGuid(componentGuid, true));
            Assert.Contains("could not find component for guid", exception.Message);
        }

        [Fact(Skip = "Requires database access for stored procedure execution - should be an integration test")]
        public void GetOverrideListOnly_ReturnsQuestionResponse()
        {
            // Arrange
            var assessmentId = 1;
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act
            var result = _componentQuestionBusiness.GetOverrideListOnly();

            // Assert
            Assert.NotNull(result);
            Assert.NotNull(result.Categories);
            Assert.Equal(0, result.QuestionCount);
            Assert.Equal(0, result.RequirementCount);
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

            // Setup Add, Update, and Remove to operate on the backing list
            mockSet.Setup(m => m.Add(It.IsAny<T>())).Callback<T>(data.Add);
            mockSet.Setup(m => m.Update(It.IsAny<T>())).Callback<T>(item =>
            {
                // Update doesn't need to do anything special for in-memory lists
            });
            mockSet.Setup(m => m.Remove(It.IsAny<T>())).Callback<T>(item => data.Remove(item));

            return mockSet;
        }

        public void Dispose()
        {
            // Cleanup if needed
        }
    }
}
