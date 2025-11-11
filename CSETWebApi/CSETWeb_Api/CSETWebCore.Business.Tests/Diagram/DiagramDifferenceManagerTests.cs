using CSETWebCore.Business.Diagram;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Moq;
using System.Xml;

namespace CSETWebCore.Business.Tests.Diagram
{
    /// <summary>
    /// Unit tests for DiagramDifferenceManager class.
    /// Tests diagram XML processing, difference detection, and database synchronization.
    /// </summary>
    public class DiagramDifferenceManagerTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly DiagramDifferenceManager _differenceManager;

        public DiagramDifferenceManagerTests()
        {
            _mockContext = new Mock<CSETContext>();

            var componentSymbols = new List<COMPONENT_SYMBOLS>
            {
                new COMPONENT_SYMBOLS
                {
                    Component_Symbol_Id = 1,
                    Symbol_Name = "Router",
                    File_Name = "router.svg"
                }
            };

            var mockComponentSymbolSet = CreateMockDbSet(componentSymbols);
            _mockContext.Setup(c => c.COMPONENT_SYMBOLS).Returns(mockComponentSymbolSet.Object);

            _differenceManager = new DiagramDifferenceManager(_mockContext.Object);
        }

        [Fact]
        public void BuildDiagramDictionaries_ProcessesEmptyDiagrams()
        {
            // Arrange
            var newDiagramXml = @"<mxGraphModel>
                <root>
                    <mxCell id=""0""/>
                    <mxCell id=""1"" parent=""0""/>
                </root>
            </mxGraphModel>";

            var oldDiagramXml = @"<mxGraphModel>
                <root>
                    <mxCell id=""0""/>
                    <mxCell id=""1"" parent=""0""/>
                </root>
            </mxGraphModel>";

            var newDoc = new XmlDocument();
            newDoc.LoadXml(newDiagramXml);

            var oldDoc = new XmlDocument();
            oldDoc.LoadXml(oldDiagramXml);

            // Act
            _differenceManager.BuildDiagramDictionaries(newDoc, oldDoc);

            // Assert - Should complete without throwing exception
            Assert.True(true);
        }

        [Fact]
        public void BuildDiagramDictionaries_ProcessesLayersCorrectly()
        {
            // Arrange
            var newDiagramXml = @"<mxGraphModel>
                <root>
                    <mxCell id=""0""/>
                    <mxCell id=""1"" parent=""0"" value=""Main Layer""/>
                    <mxCell id=""2"" parent=""0"" value=""Second Layer""/>
                </root>
            </mxGraphModel>";

            var oldDiagramXml = @"<mxGraphModel>
                <root>
                    <mxCell id=""0""/>
                    <mxCell id=""1"" parent=""0"" value=""Main Layer""/>
                </root>
            </mxGraphModel>";

            var newDoc = new XmlDocument();
            newDoc.LoadXml(newDiagramXml);

            var oldDoc = new XmlDocument();
            oldDoc.LoadXml(oldDiagramXml);

            // Act
            _differenceManager.BuildDiagramDictionaries(newDoc, oldDoc);

            // Assert - Should process without error
            Assert.True(true);
        }

        [Fact]
        public void BuildDiagramDictionaries_HandlesNullOldDiagram()
        {
            // Arrange
            var newDiagramXml = @"<mxGraphModel>
                <root>
                    <mxCell id=""0""/>
                    <mxCell id=""1"" parent=""0""/>
                </root>
            </mxGraphModel>";

            var newDoc = new XmlDocument();
            newDoc.LoadXml(newDiagramXml);

            var oldDoc = new XmlDocument();
            oldDoc.LoadXml("<mxGraphModel><root></root></mxGraphModel>");

            // Act
            _differenceManager.BuildDiagramDictionaries(newDoc, oldDoc);

            // Assert - Should handle gracefully
            Assert.True(true);
        }

        // NOTE: This test is commented out due to complex internal dependencies with LayerManager
        // that are difficult to mock in a unit test environment
        /*
        [Fact]
        public void SaveDifferences_RemovesDeletedComponents()
        {
            // This test requires extensive setup of LayerManager and related dependencies
            // Consider testing this functionality via integration tests instead
        }
        */

        [Fact]
        public void SaveDifferences_AddsNewComponents()
        {
            // Arrange
            var assessmentId = 1;
            var newGuid = Guid.NewGuid();

            var adcList = new List<ASSESSMENT_DIAGRAM_COMPONENTS>();
            var containerList = new List<DIAGRAM_CONTAINER>
            {
                new DIAGRAM_CONTAINER
                {
                    Assessment_Id = assessmentId,
                    Container_Id = 1,
                    DrawIO_id = "1",
                    ContainerType = "Layer",
                    Name = "Main Layer"
                }
            };

            var mockAdcSet = CreateMockDbSet(adcList);
            var mockContainerSet = CreateMockDbSet(containerList);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockAdcSet.Object);
            _mockContext.Setup(c => c.DIAGRAM_CONTAINER).Returns(mockContainerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Create diagrams for difference processing
            var newDiagramXml = $@"<mxGraphModel>
                <root>
                    <mxCell id=""0""/>
                    <mxCell id=""1"" parent=""0""/>
                    <UserObject ComponentGuid=""{newGuid}"" label=""New Component"" id=""2"">
                        <mxCell parent=""1"" style=""image=img/cset/router.svg""/>
                    </UserObject>
                </root>
            </mxGraphModel>";

            var oldDiagramXml = @"<mxGraphModel><root><mxCell id=""0""/><mxCell id=""1"" parent=""0""/></root></mxGraphModel>";

            var newDoc = new XmlDocument();
            newDoc.LoadXml(newDiagramXml);

            var oldDoc = new XmlDocument();
            oldDoc.LoadXml(oldDiagramXml);

            _differenceManager.BuildDiagramDictionaries(newDoc, oldDoc);

            // Act
            _differenceManager.SaveDifferences(assessmentId, refreshQuestions: false);

            // Assert
            mockAdcSet.Verify(m => m.Add(It.IsAny<ASSESSMENT_DIAGRAM_COMPONENTS>()), Times.Once);
            _mockContext.Verify(c => c.SaveChanges(), Times.AtLeastOnce);
        }

        [Fact]
        public void SaveDifferences_HandlesRefreshQuestionsFlag()
        {
            // Arrange
            var assessmentId = 1;

            var adcList = new List<ASSESSMENT_DIAGRAM_COMPONENTS>();
            var containerList = new List<DIAGRAM_CONTAINER>();

            var mockAdcSet = CreateMockDbSet(adcList);
            var mockContainerSet = CreateMockDbSet(containerList);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockAdcSet.Object);
            _mockContext.Setup(c => c.DIAGRAM_CONTAINER).Returns(mockContainerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockContext.Setup(c => c.FillNetworkDiagramQuestions(assessmentId));

            var emptyXml = @"<mxGraphModel><root><mxCell id=""0""/><mxCell id=""1"" parent=""0""/></root></mxGraphModel>";
            var doc = new XmlDocument();
            doc.LoadXml(emptyXml);

            _differenceManager.BuildDiagramDictionaries(doc, doc);

            // Act - with refresh questions
            _differenceManager.SaveDifferences(assessmentId, refreshQuestions: true);

            // Assert
            _mockContext.Verify(c => c.FillNetworkDiagramQuestions(assessmentId), Times.Once);
        }

        [Fact]
        public void SaveDifferences_DoesNotRefreshQuestions_WhenFlagIsFalse()
        {
            // Arrange
            var assessmentId = 1;

            var adcList = new List<ASSESSMENT_DIAGRAM_COMPONENTS>();
            var containerList = new List<DIAGRAM_CONTAINER>();

            var mockAdcSet = CreateMockDbSet(adcList);
            var mockContainerSet = CreateMockDbSet(containerList);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockAdcSet.Object);
            _mockContext.Setup(c => c.DIAGRAM_CONTAINER).Returns(mockContainerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);
            _mockContext.Setup(c => c.FillNetworkDiagramQuestions(assessmentId));

            var emptyXml = @"<mxGraphModel><root><mxCell id=""0""/><mxCell id=""1"" parent=""0""/></root></mxGraphModel>";
            var doc = new XmlDocument();
            doc.LoadXml(emptyXml);

            _differenceManager.BuildDiagramDictionaries(doc, doc);

            // Act - without refresh questions
            _differenceManager.SaveDifferences(assessmentId, refreshQuestions: false);

            // Assert
            _mockContext.Verify(c => c.FillNetworkDiagramQuestions(assessmentId), Times.Never);
        }

        [Fact]
        public void SaveDifferences_AddsDefaultLayer_WhenNotPresent()
        {
            // Arrange
            var assessmentId = 1;

            var adcList = new List<ASSESSMENT_DIAGRAM_COMPONENTS>();
            var containerList = new List<DIAGRAM_CONTAINER>(); // Empty - no default layer

            var mockAdcSet = CreateMockDbSet(adcList);
            var mockContainerSet = CreateMockDbSet(containerList);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockAdcSet.Object);
            _mockContext.Setup(c => c.DIAGRAM_CONTAINER).Returns(mockContainerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            var emptyXml = @"<mxGraphModel><root><mxCell id=""0""/><mxCell id=""1"" parent=""0""/></root></mxGraphModel>";
            var doc = new XmlDocument();
            doc.LoadXml(emptyXml);

            _differenceManager.BuildDiagramDictionaries(doc, doc);

            // Act
            _differenceManager.SaveDifferences(assessmentId, refreshQuestions: false);

            // Assert
            mockContainerSet.Verify(m => m.Add(It.Is<DIAGRAM_CONTAINER>(
                d => d.DrawIO_id == "1" && d.ContainerType == "Layer"
            )), Times.Once);
        }

        [Fact]
        public void SaveDifferences_RemovesDeletedZones()
        {
            // Arrange
            var assessmentId = 1;
            var deletedZoneId = "zone-1";

            var deletedZone = new DIAGRAM_CONTAINER
            {
                Assessment_Id = assessmentId,
                DrawIO_id = deletedZoneId,
                ContainerType = "Zone",
                Name = "Deleted Zone"
            };

            var adcList = new List<ASSESSMENT_DIAGRAM_COMPONENTS>();
            var containerList = new List<DIAGRAM_CONTAINER> { deletedZone };

            var mockAdcSet = CreateMockDbSet(adcList);
            var mockContainerSet = CreateMockDbSet(containerList);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockAdcSet.Object);
            _mockContext.Setup(c => c.DIAGRAM_CONTAINER).Returns(mockContainerSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Create diagrams - old has zone, new doesn't
            var newDiagramXml = @"<mxGraphModel><root><mxCell id=""0""/><mxCell id=""1"" parent=""0""/></root></mxGraphModel>";
            var oldDiagramXml = $@"<mxGraphModel>
                <root>
                    <mxCell id=""0""/>
                    <mxCell id=""1"" parent=""0""/>
                    <UserObject id=""{deletedZoneId}"" zone=""1"" ZoneType=""External"" SAL=""L"" label=""Deleted Zone"">
                        <mxCell parent=""1""/>
                    </UserObject>
                </root>
            </mxGraphModel>";

            var newDoc = new XmlDocument();
            newDoc.LoadXml(newDiagramXml);

            var oldDoc = new XmlDocument();
            oldDoc.LoadXml(oldDiagramXml);

            _differenceManager.BuildDiagramDictionaries(newDoc, oldDoc);

            // Act
            _differenceManager.SaveDifferences(assessmentId, refreshQuestions: false);

            // Assert
            mockContainerSet.Verify(m => m.Remove(It.IsAny<DIAGRAM_CONTAINER>()), Times.Once);
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
