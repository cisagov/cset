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
    /// Unit tests for RequirementBusiness class.
    /// Tests requirement retrieval, answer storage, and requirement list building.
    /// </summary>
    public class RequirementBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly Mock<IQuestionRequirementManager> _mockQuestionRequirement;
        private readonly Mock<ITokenManager> _mockTokenManager;
        private readonly RequirementBusiness _requirementBusiness;

        public RequirementBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();
            _mockQuestionRequirement = new Mock<IQuestionRequirementManager>();
            _mockTokenManager = new Mock<ITokenManager>();

            // Setup required DbSets for ParameterSubstitution
            _mockContext.Setup(c => c.PARAMETERS).Returns(CreateMockDbSet(new List<PARAMETERS>()).Object);
            _mockContext.Setup(c => c.PARAMETER_REQUIREMENTS).Returns(CreateMockDbSet(new List<PARAMETER_REQUIREMENTS>()).Object);
            _mockContext.Setup(c => c.PARAMETER_ASSESSMENT).Returns(CreateMockDbSet(new List<PARAMETER_ASSESSMENT>()).Object);
            _mockContext.Setup(c => c.PARAMETER_VALUES).Returns(CreateMockDbSet(new List<PARAMETER_VALUES>()).Object);

            _requirementBusiness = new RequirementBusiness(
                _mockAssessmentUtil.Object,
                _mockQuestionRequirement.Object,
                _mockContext.Object,
                _mockTokenManager.Object
            );
        }

        [Fact]
        public void SetRequirementAssessmentId_InitializesManager()
        {
            // Arrange
            var assessmentId = 1;
            _mockQuestionRequirement.Setup(q => q.InitializeManager(It.IsAny<int>()));

            // Act
            _requirementBusiness.SetRequirementAssessmentId(assessmentId);

            // Assert
            _mockQuestionRequirement.Verify(q => q.InitializeManager(assessmentId), Times.Once);
        }

        [Fact]
        public void StoreAnswer_CreatesNewAnswer_WhenAnswerDoesNotExist()
        {
            // Arrange
            var assessmentId = 1;
            var requirementId = 200;
            var answer = new Answer
            {
                QuestionId = requirementId,
                AnswerText = "Y",
                QuestionType = "Requirement",
                QuestionNumber = "R-1",
                Comment = "Test requirement comment"
            };

            var requirements = new List<NEW_REQUIREMENT>
            {
                new NEW_REQUIREMENT
                {
                    Requirement_Id = requirementId,
                    Requirement_Text = "Test requirement text",
                    Requirement_Title = "R-1"
                }
            };

            var answers = new List<ANSWER>();
            var mockRequirementSet = CreateMockDbSet(requirements);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(CreateMockDbSet(new List<NEW_QUESTION>()).Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(mockRequirementSet.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _requirementBusiness.StoreAnswer(answer);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(requirementId, result.QuestionId);
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
            var requirementId = 200;
            var answerId = 50;

            var existingAnswer = new ANSWER
            {
                Answer_Id = answerId,
                Assessment_Id = assessmentId,
                Question_Or_Requirement_Id = requirementId,
                Question_Type = "Requirement",
                Answer_Text = "N",
                Component_Guid = Guid.Empty
            };

            var answer = new Answer
            {
                QuestionId = requirementId,
                AnswerText = "A",
                QuestionType = "Requirement",
                QuestionNumber = "R-1",
                Comment = "Updated requirement comment"
            };

            var requirements = new List<NEW_REQUIREMENT>
            {
                new NEW_REQUIREMENT
                {
                    Requirement_Id = requirementId,
                    Requirement_Text = "Test requirement"
                }
            };

            var answers = new List<ANSWER> { existingAnswer };
            var mockRequirementSet = CreateMockDbSet(requirements);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(CreateMockDbSet(new List<NEW_QUESTION>()).Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(mockRequirementSet.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _requirementBusiness.StoreAnswer(answer);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("A", result.AnswerText);
            mockAnswerSet.Verify(m => m.Update(It.IsAny<ANSWER>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void StoreAnswer_DefaultsToUnanswered_WhenAnswerTextIsEmpty()
        {
            // Arrange
            var assessmentId = 1;
            var requirementId = 200;
            var answer = new Answer
            {
                QuestionId = requirementId,
                AnswerText = "",
                QuestionType = "Requirement",
                QuestionNumber = "R-1"
            };

            var requirements = new List<NEW_REQUIREMENT>
            {
                new NEW_REQUIREMENT { Requirement_Id = requirementId, Requirement_Text = "Test" }
            };

            var answers = new List<ANSWER>();
            var mockRequirementSet = CreateMockDbSet(requirements);
            var mockAnswerSet = CreateMockDbSet(answers);

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(CreateMockDbSet(new List<NEW_QUESTION>()).Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(mockRequirementSet.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _requirementBusiness.StoreAnswer(answer);

            // Assert
            Assert.NotNull(result);
            Assert.Equal("U", result.AnswerText);
        }

        [Fact]
        public void StoreAnswer_ThrowsException_WhenRequirementDoesNotExist()
        {
            // Arrange
            var assessmentId = 1;
            var answer = new Answer
            {
                QuestionId = 999,
                AnswerText = "Y",
                QuestionType = "Requirement",
                QuestionNumber = "R-999"
            };

            var mockQuestionSet = CreateMockDbSet(new List<NEW_QUESTION>());
            var mockRequirementSet = CreateMockDbSet(new List<NEW_REQUIREMENT>());

            _mockContext.Setup(c => c.NEW_QUESTION).Returns(mockQuestionSet.Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(mockRequirementSet.Object);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act & Assert
            var exception = Assert.Throws<Exception>(() => _requirementBusiness.StoreAnswer(answer));
            Assert.Contains("Unknown question or requirement ID", exception.Message);
        }

        [Fact]
        public void SaveAssessmentParameter_CreatesNewParameter_WhenNotExists()
        {
            // Arrange
            var assessmentId = 1;
            var parameterId = 10;
            var newText = "New parameter value";

            var parameter = new PARAMETERS
            {
                Parameter_ID = parameterId,
                Parameter_Name = "TestParam"
            };

            var parameters = new List<PARAMETERS> { parameter };
            var paramAssessments = new List<PARAMETER_ASSESSMENT>();

            var mockParameterSet = CreateMockDbSet(parameters);
            var mockParamAssessmentSet = CreateMockDbSet(paramAssessments);

            _mockContext.Setup(c => c.PARAMETERS).Returns(mockParameterSet.Object);
            _mockContext.Setup(c => c.PARAMETER_ASSESSMENT).Returns(mockParamAssessmentSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockQuestionRequirement.Setup(q => q.AssessmentId).Returns(assessmentId);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Mock Find to return null (new parameter)
            _mockContext.Setup(c => c.PARAMETER_ASSESSMENT.Find(It.IsAny<object[]>())).Returns((PARAMETER_ASSESSMENT)null);

            // Act
            var result = _requirementBusiness.SaveAssessmentParameter(parameterId, newText);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(newText, result.Substitution);
            mockParamAssessmentSet.Verify(m => m.Add(It.Is<PARAMETER_ASSESSMENT>(
                pa => pa.Parameter_ID == parameterId && pa.Parameter_Value_Assessment == newText
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void SaveAssessmentParameter_DeletesParameter_WhenEmptyTextProvided()
        {
            // Arrange
            var assessmentId = 1;
            var parameterId = 10;
            var emptyText = "";

            var parameter = new PARAMETERS
            {
                Parameter_ID = parameterId,
                Parameter_Name = "TestParam"
            };

            var paramAssessment = new PARAMETER_ASSESSMENT
            {
                Parameter_ID = parameterId,
                Assessment_ID = assessmentId,
                Parameter_Value_Assessment = "Old value"
            };

            var parameters = new List<PARAMETERS> { parameter };
            var paramAssessments = new List<PARAMETER_ASSESSMENT> { paramAssessment };

            var mockParameterSet = CreateMockDbSet(parameters);
            var mockParamAssessmentSet = CreateMockDbSet(paramAssessments);

            _mockContext.Setup(c => c.PARAMETERS).Returns(mockParameterSet.Object);
            _mockContext.Setup(c => c.PARAMETER_ASSESSMENT).Returns(mockParamAssessmentSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockQuestionRequirement.Setup(q => q.AssessmentId).Returns(assessmentId);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _requirementBusiness.SaveAssessmentParameter(parameterId, emptyText);

            // Assert
            Assert.NotNull(result);
            mockParamAssessmentSet.Verify(m => m.Remove(It.IsAny<PARAMETER_ASSESSMENT>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void GetActiveAnswerIds_ReturnsEmptyList_WhenNoRequirements()
        {
            // Arrange
            var assessmentId = 1;
            var setNames = new List<string> { "NIST" };

            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);
            _mockQuestionRequirement.Setup(q => q.AssessmentId).Returns(assessmentId);
            _mockQuestionRequirement.Setup(q => q.SetNames).Returns(setNames);
            _mockQuestionRequirement.Setup(q => q.StandardLevel).Returns("Low");

            var mockRequirementSets = CreateMockDbSet(new List<REQUIREMENT_SETS>());
            var mockSets = CreateMockDbSet(new List<SETS>());
            var mockRequirements = CreateMockDbSet(new List<NEW_REQUIREMENT>());
            var mockRequirementLevels = CreateMockDbSet(new List<REQUIREMENT_LEVELS>());
            var mockAnswers = CreateMockDbSet(new List<ANSWER>());
            var mockViewStatus = CreateMockDbSet(new List<VIEW_QUESTIONS_STATUS>());

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId, Only_Mode = false }
            };
            var mockStandardSelection = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.REQUIREMENT_SETS).Returns(mockRequirementSets.Object);
            _mockContext.Setup(c => c.SETS).Returns(mockSets.Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(mockRequirements.Object);
            _mockContext.Setup(c => c.REQUIREMENT_LEVELS).Returns(mockRequirementLevels.Object);
            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswers.Object);
            _mockContext.Setup(c => c.VIEW_QUESTIONS_STATUS).Returns(mockViewStatus.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelection.Object);

            // Act
            var result = _requirementBusiness.GetActiveAnswerIds();

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        [Fact]
        public void BuildCategoryResponse_ReturnsNewQuestionGroup()
        {
            // Act
            var result = _requirementBusiness.BuildCategoryResponse();

            // Assert
            Assert.NotNull(result);
            Assert.IsType<QuestionGroup>(result);
        }

        [Fact]
        public void BuildSubcategoryResponse_ReturnsNewQuestionSubCategory()
        {
            // Act
            var result = _requirementBusiness.BuildSubcategoryResponse();

            // Assert
            Assert.NotNull(result);
            Assert.IsType<QuestionSubCategory>(result);
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
