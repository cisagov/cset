using CSETWebCore.Business.Observations;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Observations;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Observations
{
    /// <summary>
    /// Unit tests for ObservationsManager class.
    /// Tests observation retrieval, creation, update, deletion, and action item management.
    /// </summary>
    public class ObservationsManagerTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly ObservationsManager _observationsManager;
        private readonly int _assessmentId = 1;

        public ObservationsManagerTests()
        {
            _mockContext = new Mock<CSETContext>();
            _observationsManager = new ObservationsManager(_mockContext.Object, _assessmentId);
        }

        #region GetAssessmentLevelObservations Tests

        [Fact]
        public void GetAssessmentLevelObservations_ReturnsEmptyList_WhenNoObservationsExist()
        {
            // Arrange
            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetAssessmentLevelObservations();

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        [Fact]
        public void GetAssessmentLevelObservations_ReturnsObservations_WhenObservationsExist()
        {
            // Arrange
            var importance = new IMPORTANCE
            {
                Importance_Id = 1,
                Value = "Low"
            };

            var findings = new List<FINDING>
            {
                new FINDING
                {
                    Finding_Id = 1,
                    Assessment_Id = _assessmentId,
                    Answer_Id = null,
                    Summary = "Test observation",
                    Issue = "Test issue",
                    Importance_Id = 1,
                    Importance = importance,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                }
            };

            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetAssessmentLevelObservations();

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal("Test observation", result[0].Summary);
            Assert.Equal("Test issue", result[0].Issue);
            Assert.False(result[0].AnswerLevel);
        }

        [Fact]
        public void GetAssessmentLevelObservations_ExcludesAnswerLevelObservations()
        {
            // Arrange
            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };

            var findings = new List<FINDING>
            {
                new FINDING
                {
                    Finding_Id = 1,
                    Assessment_Id = _assessmentId,
                    Answer_Id = null,
                    Summary = "Assessment level",
                    Importance = importance,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                },
                new FINDING
                {
                    Finding_Id = 2,
                    Assessment_Id = _assessmentId,
                    Answer_Id = 123,
                    Summary = "Answer level",
                    Importance = importance,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                }
            };

            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetAssessmentLevelObservations();

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal("Assessment level", result[0].Summary);
        }

        [Fact]
        public void GetAssessmentLevelObservations_SetsDefaultImportance_WhenImportanceIsNull()
        {
            // Arrange
            var findings = new List<FINDING>
            {
                new FINDING
                {
                    Finding_Id = 1,
                    Assessment_Id = _assessmentId,
                    Answer_Id = null,
                    Summary = "Test",
                    Importance = null,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                }
            };

            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetAssessmentLevelObservations();

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.NotNull(result[0].Importance);
            Assert.Equal(1, result[0].Importance.Importance_Id);
            Assert.Equal(CSETWebCore.Constants.Constants.SAL_LOW, result[0].Importance.Value);
        }

        #endregion

        #region GetAnswerLevelObservations Tests

        [Fact]
        public void GetAnswerLevelObservations_ReturnsObservations_ForAllAnswersInAssessment()
        {
            // Arrange
            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };
            var answer1 = new ANSWER { Answer_Id = 1, Assessment_Id = _assessmentId };
            var answer2 = new ANSWER { Answer_Id = 2, Assessment_Id = _assessmentId };

            var findings = new List<FINDING>
            {
                new FINDING
                {
                    Finding_Id = 1,
                    Answer_Id = 1,
                    Answer = answer1,
                    Summary = "Observation 1",
                    Importance = importance,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                },
                new FINDING
                {
                    Finding_Id = 2,
                    Answer_Id = 2,
                    Answer = answer2,
                    Summary = "Observation 2",
                    Importance = importance,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                }
            };

            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Mock the DbSets needed for question title lookup
            _mockContext.Setup(c => c.MATURITY_QUESTIONS).Returns(CreateMockDbSet(new List<MATURITY_QUESTIONS>()).Object);
            _mockContext.Setup(c => c.NEW_QUESTION).Returns(CreateMockDbSet(new List<NEW_QUESTION>()).Object);
            _mockContext.Setup(c => c.NEW_REQUIREMENT).Returns(CreateMockDbSet(new List<NEW_REQUIREMENT>()).Object);

            // Act
            var result = _observationsManager.GetAnswerLevelObservations(_assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.Count);
            Assert.Contains(result, o => o.Summary == "Observation 1");
            Assert.Contains(result, o => o.Summary == "Observation 2");
        }

        [Fact]
        public void GetAnswerLevelObservations_ReturnsEmpty_WhenNoObservationsExist()
        {
            // Arrange
            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetAnswerLevelObservations(_assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        #endregion

        #region GetObservationsForAnswer Tests

        [Fact]
        public void GetObservationsForAnswer_ReturnsObservations_ForSpecificAnswer()
        {
            // Arrange
            var answerId = 123;
            var importance = new IMPORTANCE { Importance_Id = 2, Value = "Medium" };

            var findings = new List<FINDING>
            {
                new FINDING
                {
                    Finding_Id = 1,
                    Answer_Id = answerId,
                    Summary = "Observation for answer",
                    Issue = "Security concern",
                    Importance = importance,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                },
                new FINDING
                {
                    Finding_Id = 2,
                    Answer_Id = 999,
                    Summary = "Different answer observation",
                    Importance = importance,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                }
            };

            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetObservationsForAnswer(answerId);

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal("Observation for answer", result[0].Summary);
            Assert.Equal("Security concern", result[0].Issue);
            Assert.True(result[0].AnswerLevel);
        }

        [Fact]
        public void GetObservationsForAnswer_ReturnsEmpty_WhenNoObservationsExist()
        {
            // Arrange
            var answerId = 123;
            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetObservationsForAnswer(answerId);

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        [Fact]
        public void GetObservationsForAnswer_IncludesFindingContacts()
        {
            // Arrange
            var answerId = 123;
            var importance = new IMPORTANCE { Importance_Id = 1, Value = "Low" };

            var findingContacts = new List<FINDING_CONTACT>
            {
                new FINDING_CONTACT
                {
                    Finding_Id = 1,
                    Assessment_Contact_Id = 10
                }
            };

            var findings = new List<FINDING>
            {
                new FINDING
                {
                    Finding_Id = 1,
                    Answer_Id = answerId,
                    Summary = "Test",
                    Importance = importance,
                    FINDING_CONTACT = findingContacts
                }
            };

            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetObservationsForAnswer(answerId);

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.NotNull(result[0].Observation_Contacts);
            Assert.Single(result[0].Observation_Contacts);
            Assert.Equal(10, result[0].Observation_Contacts[0].Assessment_Contact_Id);
            Assert.True(result[0].Observation_Contacts[0].Selected);
        }

        #endregion

        #region GetObservation Tests

        [Fact]
        public void GetObservation_ReturnsObservation_WhenObservationExists()
        {
            // Arrange
            var observationId = 1;
            var importance = new IMPORTANCE { Importance_Id = 3, Value = "High" };

            var findings = new List<FINDING>
            {
                new FINDING
                {
                    Finding_Id = observationId,
                    Summary = "Specific observation",
                    Issue = "Critical issue",
                    Recommendations = "Fix immediately",
                    Importance = importance,
                    FINDING_CONTACT = new List<FINDING_CONTACT>()
                }
            };

            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetObservation(observationId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(observationId, result.Observation_Id);
            Assert.Equal("Specific observation", result.Summary);
            Assert.Equal("Critical issue", result.Issue);
            Assert.Equal("Fix immediately", result.Recommendations);
        }

        [Fact]
        public void GetObservation_ReturnsNull_WhenObservationDoesNotExist()
        {
            // Arrange
            var observationId = 999;
            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            var result = _observationsManager.GetObservation(observationId);

            // Assert
            Assert.Null(result);
        }

        #endregion

        #region CreateObservationForAnswer Tests

        [Fact]
        public void CreateObservationForAnswer_CreatesNewObservation_WithAnswerId()
        {
            // Arrange
            var answerId = 123;

            // Act
            var result = _observationsManager.CreateObservationForAnswer(answerId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(answerId, result.Answer_Id);
            Assert.True(result.AnswerLevel);
        }

        #endregion

        #region UpdateObservation Tests

        [Fact]
        public void UpdateObservation_ReturnsObservationId()
        {
            // Arrange
            var observation = new Observation
            {
                Observation_Id = 1,
                Summary = "Updated summary",
                Issue = "Updated issue"
            };

            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);
            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(CreateMockDbSet(new List<IMPORTANCE>
            {
                new IMPORTANCE { Importance_Id = 1, Value = "Low" }
            }).Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            var result = _observationsManager.UpdateObservation(observation);

            // Assert
            Assert.Equal(1, result);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        #endregion

        #region DeleteObservation Tests

        [Fact]
        public void DeleteObservation_RemovesObservation_WhenObservationExists()
        {
            // Arrange
            var observationId = 1;
            var finding = new FINDING
            {
                Finding_Id = observationId,
                Summary = "To be deleted"
            };

            var findings = new List<FINDING> { finding };
            var mockFindingSet = CreateMockDbSet(findings);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _observationsManager.DeleteObservation(observationId);

            // Assert
            mockFindingSet.Verify(m => m.Remove(It.IsAny<FINDING>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void DeleteObservation_DoesNothing_WhenObservationDoesNotExist()
        {
            // Arrange
            var observationId = 999;
            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            _observationsManager.DeleteObservation(observationId);

            // Assert
            mockFindingSet.Verify(m => m.Remove(It.IsAny<FINDING>()), Times.Never);
            _mockContext.Verify(c => c.SaveChanges(), Times.Never);
        }

        #endregion

        #region GetActionItems Tests

        [Fact]
        public void GetActionItems_ReturnsActionItems_WhenDataExists()
        {
            // Arrange
            var parentId = 100;
            var observationId = 1;

            var maturityQuestions = new List<MATURITY_QUESTIONS>
            {
                new MATURITY_QUESTIONS
                {
                    Mat_Question_Id = 1,
                    Parent_Question_Id = parentId
                },
                new MATURITY_QUESTIONS
                {
                    Mat_Question_Id = 2,
                    Parent_Question_Id = parentId
                }
            };

            var iseActions = new List<ISE_ACTIONS>
            {
                new ISE_ACTIONS
                {
                    Mat_Question_Id = 1,
                    Description = "Action 1 description",
                    Action_Items = "Action 1 items",
                    Regulatory_Citation = "Citation 1"
                },
                new ISE_ACTIONS
                {
                    Mat_Question_Id = 2,
                    Description = "Action 2 description",
                    Action_Items = "Action 2 items",
                    Regulatory_Citation = "Citation 2"
                }
            };

            var iseActionsFindings = new List<ISE_ACTIONS_FINDINGS>();

            var mockMaturityQuestionsSet = CreateMockDbSet(maturityQuestions);
            var mockIseActionsSet = CreateMockDbSet(iseActions);
            var mockIseActionsFindingsSet = CreateMockDbSet(iseActionsFindings);

            _mockContext.Setup(c => c.MATURITY_QUESTIONS).Returns(mockMaturityQuestionsSet.Object);
            _mockContext.Setup(c => c.ISE_ACTIONS).Returns(mockIseActionsSet.Object);
            _mockContext.Setup(c => c.ISE_ACTIONS_FINDINGS).Returns(mockIseActionsFindingsSet.Object);

            // Act
            var result = _observationsManager.GetActionItems(parentId, observationId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.Count);
            Assert.Contains(result, a => a.Description == "Action 1 description");
            Assert.Contains(result, a => a.Description == "Action 2 description");
        }

        [Fact]
        public void GetActionItems_ReturnsOverriddenActionItems_WhenOverrideExists()
        {
            // Arrange
            var parentId = 100;
            var observationId = 1;

            var maturityQuestions = new List<MATURITY_QUESTIONS>
            {
                new MATURITY_QUESTIONS
                {
                    Mat_Question_Id = 1,
                    Parent_Question_Id = parentId
                }
            };

            var iseActions = new List<ISE_ACTIONS>
            {
                new ISE_ACTIONS
                {
                    Mat_Question_Id = 1,
                    Description = "Action description",
                    Action_Items = "Original action items",
                    Regulatory_Citation = "Citation"
                }
            };

            var iseActionsFindings = new List<ISE_ACTIONS_FINDINGS>
            {
                new ISE_ACTIONS_FINDINGS
                {
                    Mat_Question_Id = 1,
                    Finding_Id = observationId,
                    Action_Items_Override = "Overridden action items"
                }
            };

            var mockMaturityQuestionsSet = CreateMockDbSet(maturityQuestions);
            var mockIseActionsSet = CreateMockDbSet(iseActions);
            var mockIseActionsFindingsSet = CreateMockDbSet(iseActionsFindings);

            _mockContext.Setup(c => c.MATURITY_QUESTIONS).Returns(mockMaturityQuestionsSet.Object);
            _mockContext.Setup(c => c.ISE_ACTIONS).Returns(mockIseActionsSet.Object);
            _mockContext.Setup(c => c.ISE_ACTIONS_FINDINGS).Returns(mockIseActionsFindingsSet.Object);

            // Act
            var result = _observationsManager.GetActionItems(parentId, observationId);

            // Assert
            Assert.NotNull(result);
            Assert.Single(result);
            Assert.Equal("Overridden action items", result[0].Action_Items);
        }

        [Fact]
        public void GetActionItems_ReturnsEmpty_WhenNoMatchingQuestionsExist()
        {
            // Arrange
            var parentId = 999;
            var observationId = 1;

            var maturityQuestions = new List<MATURITY_QUESTIONS>();
            var iseActions = new List<ISE_ACTIONS>();
            var iseActionsFindings = new List<ISE_ACTIONS_FINDINGS>();

            _mockContext.Setup(c => c.MATURITY_QUESTIONS).Returns(CreateMockDbSet(maturityQuestions).Object);
            _mockContext.Setup(c => c.ISE_ACTIONS).Returns(CreateMockDbSet(iseActions).Object);
            _mockContext.Setup(c => c.ISE_ACTIONS_FINDINGS).Returns(CreateMockDbSet(iseActionsFindings).Object);

            // Act
            var result = _observationsManager.GetActionItems(parentId, observationId);

            // Assert
            Assert.NotNull(result);
            Assert.Empty(result);
        }

        #endregion

        #region UpdateIssues Tests

        [Fact]
        public void UpdateIssues_CreatesNewRecord_WhenOverrideDoesNotExist()
        {
            // Arrange
            var observationId = 1;
            var actionItemTextUpdate = new ActionItemTextUpdate
            {
                observation_Id = observationId,
                actionTextItems = new List<ActionItemText>
                {
                    new ActionItemText
                    {
                        Mat_Question_Id = 100,
                        ActionItemOverrideText = "New override text"
                    }
                }
            };

            var iseActionsFindings = new List<ISE_ACTIONS_FINDINGS>();
            var mockIseActionsFindingsSet = CreateMockDbSet(iseActionsFindings);

            _mockContext.Setup(c => c.ISE_ACTIONS_FINDINGS).Returns(mockIseActionsFindingsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _observationsManager.UpdateIssues(actionItemTextUpdate);

            // Assert
            mockIseActionsFindingsSet.Verify(m => m.Add(It.Is<ISE_ACTIONS_FINDINGS>(
                x => x.Mat_Question_Id == 100 &&
                     x.Finding_Id == observationId &&
                     x.Action_Items_Override == "New override text"
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void UpdateIssues_UpdatesExistingRecord_WhenOverrideExists()
        {
            // Arrange
            var observationId = 1;
            var matQuestionId = 100;

            var existingRecord = new ISE_ACTIONS_FINDINGS
            {
                Mat_Question_Id = matQuestionId,
                Finding_Id = observationId,
                Action_Items_Override = "Old override text"
            };

            var iseActionsFindings = new List<ISE_ACTIONS_FINDINGS> { existingRecord };
            var mockIseActionsFindingsSet = CreateMockDbSet(iseActionsFindings);

            var actionItemTextUpdate = new ActionItemTextUpdate
            {
                observation_Id = observationId,
                actionTextItems = new List<ActionItemText>
                {
                    new ActionItemText
                    {
                        Mat_Question_Id = matQuestionId,
                        ActionItemOverrideText = "Updated override text"
                    }
                }
            };

            _mockContext.Setup(c => c.ISE_ACTIONS_FINDINGS).Returns(mockIseActionsFindingsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _observationsManager.UpdateIssues(actionItemTextUpdate);

            // Assert
            Assert.Equal("Updated override text", existingRecord.Action_Items_Override);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
            mockIseActionsFindingsSet.Verify(m => m.Add(It.IsAny<ISE_ACTIONS_FINDINGS>()), Times.Never);
        }

        [Fact]
        public void UpdateIssues_HandlesMultipleActionItems()
        {
            // Arrange
            var observationId = 1;
            var actionItemTextUpdate = new ActionItemTextUpdate
            {
                observation_Id = observationId,
                actionTextItems = new List<ActionItemText>
                {
                    new ActionItemText { Mat_Question_Id = 100, ActionItemOverrideText = "Override 1" },
                    new ActionItemText { Mat_Question_Id = 101, ActionItemOverrideText = "Override 2" },
                    new ActionItemText { Mat_Question_Id = 102, ActionItemOverrideText = "Override 3" }
                }
            };

            var iseActionsFindings = new List<ISE_ACTIONS_FINDINGS>();
            var mockIseActionsFindingsSet = CreateMockDbSet(iseActionsFindings);

            _mockContext.Setup(c => c.ISE_ACTIONS_FINDINGS).Returns(mockIseActionsFindingsSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _observationsManager.UpdateIssues(actionItemTextUpdate);

            // Assert
            mockIseActionsFindingsSet.Verify(m => m.Add(It.IsAny<ISE_ACTIONS_FINDINGS>()), Times.Exactly(3));
            _mockContext.Verify(c => c.SaveChanges(), Times.Exactly(3));
        }

        #endregion

        #region BuildAutoObservation Tests

        [Fact]
        public void BuildAutoObservation_CreatesObservation_WhenNoExistingAutoObservationExists()
        {
            // Arrange
            var answer = new CSETWebCore.Model.Question.Answer
            {
                AnswerId = 123,
                QuestionId = 100
            };

            var maturityQuestionProps = new List<MATURITY_QUESTION_PROPS>
            {
                new MATURITY_QUESTION_PROPS
                {
                    Mat_Question_Id = 100,
                    PropertyName = "OBS-DISCOVERY",
                    PropertyValue = "Discovery summary"
                },
                new MATURITY_QUESTION_PROPS
                {
                    Mat_Question_Id = 100,
                    PropertyName = "OBS-RISK-STATEMENT",
                    PropertyValue = "Risk statement"
                },
                new MATURITY_QUESTION_PROPS
                {
                    Mat_Question_Id = 100,
                    PropertyName = "OBS-RECOMMENDATION",
                    PropertyValue = "Recommendation text"
                }
            };

            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);
            var mockPropsSet = CreateMockDbSet(maturityQuestionProps);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.MATURITY_QUESTION_PROPS).Returns(mockPropsSet.Object);
            _mockContext.Setup(c => c.IMPORTANCE).Returns(CreateMockDbSet(new List<IMPORTANCE>
            {
                new IMPORTANCE { Importance_Id = 1, Value = "Low" }
            }).Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _observationsManager.BuildAutoObservation(answer);

            // Assert
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void BuildAutoObservation_DoesNotCreateDuplicate_WhenAutoObservationAlreadyExists()
        {
            // Arrange
            var answer = new CSETWebCore.Model.Question.Answer
            {
                AnswerId = 123,
                QuestionId = 100
            };

            var existingFinding = new FINDING
            {
                Finding_Id = 1,
                Answer_Id = 123,
                Auto_Generated = CSETWebCore.Constants.Constants.ObsCreatedByVadr
            };

            var findings = new List<FINDING> { existingFinding };
            var mockFindingSet = CreateMockDbSet(findings);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            _observationsManager.BuildAutoObservation(answer);

            // Assert
            _mockContext.Verify(c => c.SaveChanges(), Times.Never);
        }

        #endregion

        #region DeleteAutoObservation Tests

        [Fact]
        public void DeleteAutoObservation_RemovesAutoObservations_WhenTheyExist()
        {
            // Arrange
            var answer = new CSETWebCore.Model.Question.Answer
            {
                AnswerId = 123
            };

            var autoObservations = new List<FINDING>
            {
                new FINDING
                {
                    Finding_Id = 1,
                    Answer_Id = 123,
                    Auto_Generated = CSETWebCore.Constants.Constants.ObsCreatedByVadr
                },
                new FINDING
                {
                    Finding_Id = 2,
                    Answer_Id = 123,
                    Auto_Generated = CSETWebCore.Constants.Constants.ObsCreatedByVadr
                }
            };

            var findings = new List<FINDING>(autoObservations);
            var mockFindingSet = CreateMockDbSet(findings);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _observationsManager.DeleteAutoObservation(answer);

            // Assert
            _mockContext.Verify(c => c.RemoveRange(It.IsAny<IEnumerable<FINDING>>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void DeleteAutoObservation_DoesNothing_WhenNoAutoObservationsExist()
        {
            // Arrange
            var answer = new CSETWebCore.Model.Question.Answer
            {
                AnswerId = 123
            };

            var findings = new List<FINDING>();
            var mockFindingSet = CreateMockDbSet(findings);

            _mockContext.Setup(c => c.FINDING).Returns(mockFindingSet.Object);

            // Act
            _observationsManager.DeleteAutoObservation(answer);

            // Assert
            _mockContext.Verify(c => c.RemoveRange(It.IsAny<IEnumerable<FINDING>>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        #endregion

        #region BuildEmptyAnswer Tests

        [Fact]
        public void BuildEmptyAnswer_CreatesNewAnswer_WhenQuestionIdIsProvided()
        {
            // Arrange
            var assessmentId = 1;
            var observation = new Observation
            {
                Question_Id = 100,
                Question_Type = "Question"
            };

            var answers = new List<ANSWER>();
            var mockAnswerSet = CreateMockDbSet(answers);
            ANSWER capturedAnswer = null;

            mockAnswerSet.Setup(m => m.Add(It.IsAny<ANSWER>()))
                .Callback<ANSWER>(a =>
                {
                    capturedAnswer = a;
                    a.Answer_Id = 456; // Simulate database setting the Answer_Id
                    answers.Add(a);
                });

            _mockContext.Setup(c => c.ANSWER).Returns(mockAnswerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            var result = _observationsManager.BuildEmptyAnswer(assessmentId, observation);

            // Assert
            Assert.Equal(456, result);
            Assert.NotNull(capturedAnswer);
            Assert.Equal(assessmentId, capturedAnswer.Assessment_Id);
            Assert.Equal(100, capturedAnswer.Question_Or_Requirement_Id);
            Assert.Equal("U", capturedAnswer.Answer_Text);
            Assert.Equal("Question", capturedAnswer.Question_Type);
            Assert.False(capturedAnswer.Mark_For_Review);
            Assert.False(capturedAnswer.Reviewed);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void BuildEmptyAnswer_ReturnsZero_WhenQuestionIdIsNull()
        {
            // Arrange
            var assessmentId = 1;
            var observation = new Observation
            {
                Question_Id = null
            };

            // Act
            var result = _observationsManager.BuildEmptyAnswer(assessmentId, observation);

            // Assert
            Assert.Equal(0, result);
            _mockContext.Verify(c => c.SaveChanges(), Times.Never);
        }

        #endregion

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
