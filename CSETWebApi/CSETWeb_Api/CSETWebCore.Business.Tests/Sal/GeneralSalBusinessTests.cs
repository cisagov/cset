using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Sal;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Sal
{
    /// <summary>
    /// Unit tests for GeneralSalBusiness class.
    /// Tests General SAL calculation, weight-based SAL determination, and slider value operations.
    /// </summary>
    public class GeneralSalBusinessTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Mock<ITokenManager> _mockTokenManager;
        private readonly Mock<IAssessmentUtil> _mockAssessmentUtil;
        private readonly GeneralSalBusiness _generalSalBusiness;

        public GeneralSalBusinessTests()
        {
            _mockContext = new Mock<CSETContext>();
            _mockTokenManager = new Mock<ITokenManager>();
            _mockAssessmentUtil = new Mock<IAssessmentUtil>();

            _generalSalBusiness = new GeneralSalBusiness(
                _mockContext.Object,
                _mockTokenManager.Object,
                _mockAssessmentUtil.Object
            );
        }

        [Fact]
        public void GetCurrentSAL_ReturnsLow_WhenWeightIsBelowModerateThreshold()
        {
            // Arrange
            var assessmentId = 1;

            var generalSal = new List<GENERAL_SAL>
            {
                new GENERAL_SAL { Assessment_Id = assessmentId, Sal_Name = "Slider1", Slider_Value = 1 }
            };
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "Slider1", Slider_Value = 1, Weight = 100 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act
            var result = _generalSalBusiness.GetCurrentSAL(assessmentId);

            // Assert
            Assert.Equal("Low", result);
        }

        [Fact]
        public void GetCurrentSAL_ReturnsModerate_WhenWeightIsInModerateRange()
        {
            // Arrange
            var assessmentId = 1;

            var generalSal = new List<GENERAL_SAL>
            {
                new GENERAL_SAL { Assessment_Id = assessmentId, Sal_Name = "Slider1", Slider_Value = 3 }
            };
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "Slider1", Slider_Value = 3, Weight = 300 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act
            var result = _generalSalBusiness.GetCurrentSAL(assessmentId);

            // Assert
            Assert.Equal("Moderate", result);
        }

        [Fact]
        public void GetCurrentSAL_ReturnsHigh_WhenWeightIsInHighRange()
        {
            // Arrange
            var assessmentId = 1;

            var generalSal = new List<GENERAL_SAL>
            {
                new GENERAL_SAL { Assessment_Id = assessmentId, Sal_Name = "Slider1", Slider_Value = 5 }
            };
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "Slider1", Slider_Value = 5, Weight = 1500 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act
            var result = _generalSalBusiness.GetCurrentSAL(assessmentId);

            // Assert
            Assert.Equal("High", result);
        }

        [Fact]
        public void GetCurrentSAL_ReturnsVeryHigh_WhenWeightIsAboveHighThreshold()
        {
            // Arrange
            var assessmentId = 1;

            var generalSal = new List<GENERAL_SAL>
            {
                new GENERAL_SAL { Assessment_Id = assessmentId, Sal_Name = "Slider1", Slider_Value = 10 }
            };
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "Slider1", Slider_Value = 10, Weight = 25000 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act
            var result = _generalSalBusiness.GetCurrentSAL(assessmentId);

            // Assert
            Assert.Equal("Very High", result);
        }

        [Fact]
        public void GetCurrentSAL_SumsMultipleWeights()
        {
            // Arrange
            var assessmentId = 1;

            var generalSal = new List<GENERAL_SAL>
            {
                new GENERAL_SAL { Assessment_Id = assessmentId, Sal_Name = "Slider1", Slider_Value = 2 },
                new GENERAL_SAL { Assessment_Id = assessmentId, Sal_Name = "Slider2", Slider_Value = 3 }
            };
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "Slider1", Slider_Value = 2, Weight = 100 },
                new GEN_SAL_WEIGHTS { Sal_Name = "Slider2", Slider_Value = 3, Weight = 200 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act - Weight sum = 300, should be Moderate
            var result = _generalSalBusiness.GetCurrentSAL(assessmentId);

            // Assert
            Assert.Equal("Moderate", result);
        }

        [Fact]
        public void SaveWeightAndCalculate_CreatesNewEntry_WhenNotExists()
        {
            // Arrange
            var saveWeight = new SaveWeight
            {
                assessmentid = 1,
                slidername = "NewSlider",
                Slider_Value = 3
            };

            var generalSal = new List<GENERAL_SAL>();
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "NewSlider", Slider_Value = 3, Weight = 300 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = 1, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _generalSalBusiness.SaveWeightAndCalculate(saveWeight);

            // Assert
            mockGeneralSalSet.Verify(m => m.Add(It.Is<GENERAL_SAL>(
                g => g.Assessment_Id == 1 &&
                     g.Sal_Name == "NewSlider" &&
                     g.Slider_Value == 3
            )), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
            _mockAssessmentUtil.Verify(a => a.TouchAssessment(1), Times.Once);
        }

        [Fact]
        public void SaveWeightAndCalculate_UpdatesExistingEntry_WhenExists()
        {
            // Arrange
            var existingEntry = new GENERAL_SAL
            {
                Assessment_Id = 1,
                Sal_Name = "ExistingSlider",
                Slider_Value = 2
            };

            var saveWeight = new SaveWeight
            {
                assessmentid = 1,
                slidername = "ExistingSlider",
                Slider_Value = 5
            };

            var generalSal = new List<GENERAL_SAL> { existingEntry };
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "ExistingSlider", Slider_Value = 5, Weight = 1500 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = 1, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _generalSalBusiness.SaveWeightAndCalculate(saveWeight);

            // Assert
            Assert.Equal(5, existingEntry.Slider_Value);
            mockGeneralSalSet.Verify(m => m.Add(It.IsAny<GENERAL_SAL>()), Times.Never);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
        }

        [Fact]
        public void SaveWeightAndCalculate_ReturnsCalculatedSAL()
        {
            // Arrange
            var saveWeight = new SaveWeight
            {
                assessmentid = 1,
                slidername = "TestSlider",
                Slider_Value = 5
            };

            var generalSal = new List<GENERAL_SAL>
            {
                new GENERAL_SAL { Assessment_Id = 1, Sal_Name = "TestSlider", Slider_Value = 5 }
            };
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "TestSlider", Slider_Value = 5, Weight = 1500 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = 1, Selected_Sal_Level = "Low" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(1);
            _mockAssessmentUtil.Setup(a => a.TouchAssessment(It.IsAny<int>()));

            // Act
            var result = _generalSalBusiness.SaveWeightAndCalculate(saveWeight);

            // Assert - Weight of 1500 should result in "High" (threshold 1000-19999)
            Assert.Equal("High", result);
        }

        [Fact]
        public void GetSavedSALValue_ReturnsExistingValue()
        {
            // Arrange
            var assessmentId = 1;
            var standardSelection = new List<STANDARD_SELECTION>
            {
                new STANDARD_SELECTION { Assessment_Id = assessmentId, Selected_Sal_Level = "Moderate" }
            };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);

            // Act
            var result = _generalSalBusiness.GetSavedSALValue(assessmentId);

            // Assert
            Assert.Equal("Moderate", result);
        }

        [Fact]
        public void GetSavedSALValue_ReturnsLow_WhenNoRecordExists()
        {
            // Arrange
            var assessmentId = 1;
            var standardSelection = new List<STANDARD_SELECTION>();
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);

            // Act
            var result = _generalSalBusiness.GetSavedSALValue(assessmentId);

            // Assert
            Assert.Equal("Low", result);
        }

        [Fact]
        public void GetCurrentSAL_PersistsSALToDatabase()
        {
            // Arrange
            var assessmentId = 1;

            var generalSal = new List<GENERAL_SAL>
            {
                new GENERAL_SAL { Assessment_Id = assessmentId, Sal_Name = "Slider1", Slider_Value = 3 }
            };
            var mockGeneralSalSet = CreateMockDbSet(generalSal);

            var weights = new List<GEN_SAL_WEIGHTS>
            {
                new GEN_SAL_WEIGHTS { Sal_Name = "Slider1", Slider_Value = 3, Weight = 300 }
            };
            var mockWeightsSet = CreateMockDbSet(weights);

            var standardSelectionEntry = new STANDARD_SELECTION
            {
                Assessment_Id = assessmentId,
                Selected_Sal_Level = "Low"
            };
            var standardSelection = new List<STANDARD_SELECTION> { standardSelectionEntry };
            var mockStandardSelectionSet = CreateMockDbSet(standardSelection);

            _mockContext.Setup(c => c.GENERAL_SAL).Returns(mockGeneralSalSet.Object);
            _mockContext.Setup(c => c.GEN_SAL_WEIGHTS).Returns(mockWeightsSet.Object);
            _mockContext.Setup(c => c.STANDARD_SELECTION).Returns(mockStandardSelectionSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockTokenManager.Setup(t => t.AssessmentForUser()).Returns(assessmentId);

            // Act
            var result = _generalSalBusiness.GetCurrentSAL(assessmentId);

            // Assert
            Assert.Equal("Moderate", standardSelectionEntry.Selected_Sal_Level);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
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
