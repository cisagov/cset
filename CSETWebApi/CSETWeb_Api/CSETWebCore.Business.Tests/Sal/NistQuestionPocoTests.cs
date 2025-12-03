using CSETWebCore.Business.Sal;

namespace CSETWebCore.Business.Tests.Sal
{
    /// <summary>
    /// Unit tests for NistQuestionPoco class.
    /// Tests answer text interpretation and IsAnswerYes property logic.
    /// </summary>
    public class NistQuestionPocoTests
    {
        [Fact]
        public void IsAnswerYes_ReturnsTrue_WhenAnswerIsY()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = "Y"
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsAnswerYes_ReturnsTrue_WhenAnswerIsYes()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = "Yes"
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsAnswerYes_ReturnsTrue_WhenAnswerIsYesCaseInsensitive()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = "YES"
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsAnswerYes_ReturnsTrue_WhenAnswerIsYesMixedCase()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = "yEs"
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void IsAnswerYes_ReturnsFalse_WhenAnswerIsN()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = "N"
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsAnswerYes_ReturnsFalse_WhenAnswerIsNo()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = "No"
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsAnswerYes_ReturnsFalse_WhenAnswerIsUnanswered()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = "U"
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsAnswerYes_ReturnsFalse_WhenAnswerIsEmpty()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = ""
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void IsAnswerYes_ReturnsFalse_WhenAnswerIsNull()
        {
            // Arrange
            var poco = new NistQuestionPoco
            {
                Question_Id = 1,
                Simple_Question = "Test Question",
                Question_Answer = null
            };

            // Act
            var result = poco.IsAnswerYes;

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void Question_Answer_CanBeSetAndRetrieved()
        {
            // Arrange
            var poco = new NistQuestionPoco();

            // Act
            poco.Question_Answer = "Yes";

            // Assert
            Assert.Equal("Yes", poco.Question_Answer);
        }

        [Fact]
        public void QuestionNumber_CanBeSetAndRetrieved()
        {
            // Arrange
            var poco = new NistQuestionPoco();

            // Act
            poco.QuestionNumber = 5;

            // Assert
            Assert.Equal(5, poco.QuestionNumber);
        }

        [Fact]
        public void Question_Id_CanBeSetAndRetrieved()
        {
            // Arrange
            var poco = new NistQuestionPoco();

            // Act
            poco.Question_Id = 100;

            // Assert
            Assert.Equal(100, poco.Question_Id);
        }

        [Fact]
        public void Simple_Question_CanBeSetAndRetrieved()
        {
            // Arrange
            var poco = new NistQuestionPoco();
            var questionText = "Is this a test question?";

            // Act
            poco.Simple_Question = questionText;

            // Assert
            Assert.Equal(questionText, poco.Simple_Question);
        }
    }
}
