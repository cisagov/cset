////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Business.Diagram;
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Moq;

namespace CSETWebCore.Business.Tests.Diagram
{
    /// <summary>
    /// Unit tests for DiagramManager class.
    /// Tests diagram retrieval, component symbols, and diagram metadata operations.
    /// </summary>
    public class DiagramManagerTests : IDisposable
    {
        private readonly Mock<CSETContext> _mockContext;
        private readonly Hooks _hooks;
        private readonly DiagramManager _diagramManager;

        public DiagramManagerTests()
        {
            _mockContext = new Mock<CSETContext>();
            _hooks = new Hooks(_mockContext.Object);
            _diagramManager = new DiagramManager(_mockContext.Object, _hooks);
        }

        [Fact]
        public void HasDiagram_ReturnsTrue_WhenDiagramExists()
        {
            // Arrange
            var assessmentId = 1;
            var assessments = new List<ASSESSMENTS>
            {
                new ASSESSMENTS
                {
                    Assessment_Id = assessmentId,
                    Diagram_Markup = "<mxGraphModel><root></root></mxGraphModel>"
                }
            };

            var mockAssessmentSet = CreateMockDbSet(assessments);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _diagramManager.HasDiagram(assessmentId);

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void HasDiagram_ReturnsFalse_WhenDiagramDoesNotExist()
        {
            // Arrange
            var assessmentId = 1;
            var assessments = new List<ASSESSMENTS>
            {
                new ASSESSMENTS
                {
                    Assessment_Id = assessmentId,
                    Diagram_Markup = null
                }
            };

            var mockAssessmentSet = CreateMockDbSet(assessments);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _diagramManager.HasDiagram(assessmentId);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void HasDiagram_ReturnsFalse_WhenAssessmentDoesNotExist()
        {
            // Arrange
            var assessmentId = 999;
            var assessments = new List<ASSESSMENTS>();

            var mockAssessmentSet = CreateMockDbSet(assessments);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _diagramManager.HasDiagram(assessmentId);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void GetDiagram_ReturnsDiagramResponse_WhenDiagramExists()
        {
            // Arrange
            var assessmentId = 1;
            var diagramMarkup = "<mxGraphModel><root></root></mxGraphModel>";
            var lastUsedComponentNumber = 42;

            var assessments = new List<ASSESSMENTS>
            {
                new ASSESSMENTS
                {
                    Assessment_Id = assessmentId,
                    Diagram_Markup = diagramMarkup,
                    LastUsedComponentNumber = lastUsedComponentNumber,
                    AnalyzeDiagram = true
                }
            };

            var mockAssessmentSet = CreateMockDbSet(assessments);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _diagramManager.GetDiagram(assessmentId);

            // Assert
            Assert.NotNull(result);
            Assert.Equal(diagramMarkup, result.DiagramXml);
            Assert.Equal(lastUsedComponentNumber, result.LastUsedComponentNumber);
            Assert.True(result.AnalyzeDiagram);
        }

        [Fact]
        public void GetDiagram_ReturnsNull_WhenAssessmentDoesNotExist()
        {
            // Arrange
            var assessmentId = 999;
            var assessments = new List<ASSESSMENTS>();

            var mockAssessmentSet = CreateMockDbSet(assessments);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);

            // Act
            var result = _diagramManager.GetDiagram(assessmentId);

            // Assert
            Assert.Null(result);
        }

        [Fact]
        public void GetComponentSymbols_ReturnsGroupedSymbols()
        {
            // Arrange
            var symbolGroups = new List<SYMBOL_GROUPS>
            {
                new SYMBOL_GROUPS { Id = 1, Symbol_Group_Name = "Network", Symbol_Group_Title = "Network Devices" },
                new SYMBOL_GROUPS { Id = 2, Symbol_Group_Name = "Server", Symbol_Group_Title = "Servers" }
            };

            var componentSymbols = new List<COMPONENT_SYMBOLS>
            {
                new COMPONENT_SYMBOLS
                {
                    Component_Symbol_Id = 1,
                    Symbol_Group_Id = 1,
                    Symbol_Name = "Router",
                    Abbreviation = "RTR",
                    File_Name = "router.svg",
                    Component_Family_Name = "Network",
                    Search_Tags = "network,router",
                    Width = 50,
                    Height = 50
                },
                new COMPONENT_SYMBOLS
                {
                    Component_Symbol_Id = 2,
                    Symbol_Group_Id = 1,
                    Symbol_Name = "Switch",
                    Abbreviation = "SW",
                    File_Name = "switch.svg",
                    Component_Family_Name = "Network",
                    Search_Tags = "network,switch",
                    Width = 50,
                    Height = 50
                },
                new COMPONENT_SYMBOLS
                {
                    Component_Symbol_Id = 3,
                    Symbol_Group_Id = 2,
                    Symbol_Name = "Web Server",
                    Abbreviation = "WEB",
                    File_Name = "webserver.svg",
                    Component_Family_Name = "Server",
                    Search_Tags = "server,web",
                    Width = 60,
                    Height = 60
                }
            };

            var mockSymbolGroupSet = CreateMockDbSet(symbolGroups);
            var mockComponentSymbolSet = CreateMockDbSet(componentSymbols);

            _mockContext.Setup(c => c.SYMBOL_GROUPS).Returns(mockSymbolGroupSet.Object);
            _mockContext.Setup(c => c.COMPONENT_SYMBOLS).Returns(mockComponentSymbolSet.Object);

            // Act
            var result = _diagramManager.GetComponentSymbols();

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.Count);

            var networkGroup = result.First(g => g.GroupName == "Network");
            Assert.Equal(2, networkGroup.Symbols.Count);
            Assert.Contains(networkGroup.Symbols, s => s.Symbol_Name == "Router");
            Assert.Contains(networkGroup.Symbols, s => s.Symbol_Name == "Switch");

            var serverGroup = result.First(g => g.GroupName == "Server");
            Assert.Single(serverGroup.Symbols);
            Assert.Contains(serverGroup.Symbols, s => s.Symbol_Name == "Web Server");
        }

        [Fact]
        public void GetAllComponentSymbols_ReturnsAllSymbolsUngrouped()
        {
            // Arrange
            var componentSymbols = new List<COMPONENT_SYMBOLS>
            {
                new COMPONENT_SYMBOLS
                {
                    Component_Symbol_Id = 1,
                    Symbol_Name = "Router",
                    Abbreviation = "RTR",
                    File_Name = "router.svg",
                    Component_Family_Name = "Network",
                    Search_Tags = "network,router",
                    Width = 50,
                    Height = 50
                },
                new COMPONENT_SYMBOLS
                {
                    Component_Symbol_Id = 2,
                    Symbol_Name = "Firewall",
                    Abbreviation = "FW",
                    File_Name = "firewall.svg",
                    Component_Family_Name = "Security",
                    Search_Tags = "security,firewall",
                    Width = 50,
                    Height = 50
                }
            };

            var mockComponentSymbolSet = CreateMockDbSet(componentSymbols);
            _mockContext.Setup(c => c.COMPONENT_SYMBOLS).Returns(mockComponentSymbolSet.Object);

            // Act
            var result = _diagramManager.GetAllComponentSymbols();

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.Count);
            Assert.Contains(result, s => s.Symbol_Name == "Router");
            Assert.Contains(result, s => s.Symbol_Name == "Firewall");
            Assert.All(result, s =>
            {
                Assert.NotNull(s.Symbol_Name);
                Assert.NotNull(s.FileName);
            });
        }

        [Fact]
        public void UpdateComponentLabel_UpdatesLabelInDatabaseAndXml()
        {
            // Arrange
            var assessmentId = 1;
            var componentGuid = Guid.NewGuid();
            var oldLabel = "Old Label";
            var newLabel = "New Label";

            var diagramMarkup = $@"<mxGraphModel>
                <root>
                    <UserObject ComponentGuid=""{componentGuid}"" label=""{oldLabel}"" id=""1"">
                        <mxCell parent=""0""/>
                    </UserObject>
                </root>
            </mxGraphModel>";

            var assessmentDiagramComponent = new ASSESSMENT_DIAGRAM_COMPONENTS
            {
                Assessment_Id = assessmentId,
                Component_Guid = componentGuid,
                label = oldLabel
            };

            var assessment = new ASSESSMENTS
            {
                Assessment_Id = assessmentId,
                Diagram_Markup = diagramMarkup
            };

            var adcList = new List<ASSESSMENT_DIAGRAM_COMPONENTS> { assessmentDiagramComponent };
            var assessmentList = new List<ASSESSMENTS> { assessment };

            var mockAdcSet = CreateMockDbSet(adcList);
            var mockAssessmentSet = CreateMockDbSet(assessmentList);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockAdcSet.Object);
            _mockContext.Setup(c => c.ASSESSMENTS).Returns(mockAssessmentSet.Object);
            _mockContext.Setup(c => c.SaveChanges()).Returns(1);

            // Act
            _diagramManager.UpdateComponentLabel(assessmentId, componentGuid.ToString(), newLabel);

            // Assert
            Assert.Equal(newLabel, assessmentDiagramComponent.label);
            _mockContext.Verify(c => c.SaveChanges(), Times.Once);
        }

        [Fact]
        public void UpdateComponentLabel_DoesNothing_WhenComponentNotFound()
        {
            // Arrange
            var assessmentId = 1;
            var componentGuid = Guid.NewGuid();
            var newLabel = "New Label";

            var adcList = new List<ASSESSMENT_DIAGRAM_COMPONENTS>();
            var mockAdcSet = CreateMockDbSet(adcList);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockAdcSet.Object);

            // Act
            _diagramManager.UpdateComponentLabel(assessmentId, componentGuid.ToString(), newLabel);

            // Assert
            _mockContext.Verify(c => c.SaveChanges(), Times.Never);
        }

        [Fact]
        public void UpdateComponentLabel_DoesNothing_WhenLabelIsNull()
        {
            // Arrange
            var assessmentId = 1;
            var componentGuid = Guid.NewGuid();
            string? newLabel = null;

            var assessmentDiagramComponent = new ASSESSMENT_DIAGRAM_COMPONENTS
            {
                Assessment_Id = assessmentId,
                Component_Guid = componentGuid,
                label = "Original Label"
            };

            var adcList = new List<ASSESSMENT_DIAGRAM_COMPONENTS> { assessmentDiagramComponent };
            var mockAdcSet = CreateMockDbSet(adcList);

            _mockContext.Setup(c => c.ASSESSMENT_DIAGRAM_COMPONENTS).Returns(mockAdcSet.Object);

            // Act
            _diagramManager.UpdateComponentLabel(assessmentId, componentGuid.ToString(), newLabel);

            // Assert
            _mockContext.Verify(c => c.SaveChanges(), Times.Never);
        }

        [Fact]
        public void SetImage_UpdatesImagePathInStyle()
        {
            // Arrange
            var componentSymbolId = 1;
            var style = "whiteSpace=wrap;html=1;image=img/cset/old_image.svg;labelBackgroundColor=none;";

            var componentSymbols = new List<COMPONENT_SYMBOLS>
            {
                new COMPONENT_SYMBOLS
                {
                    Component_Symbol_Id = componentSymbolId,
                    File_Name = "new_image.svg"
                }
            };

            var mockComponentSymbolSet = CreateMockDbSet(componentSymbols);
            _mockContext.Setup(c => c.COMPONENT_SYMBOLS).Returns(mockComponentSymbolSet.Object);

            // Act
            var result = _diagramManager.SetImage(componentSymbolId, style);

            // Assert
            Assert.Contains("image=img/cset/new_image.svg", result);
            Assert.DoesNotContain("old_image.svg", result);
        }

        [Fact]
        public void GetDiagramTemplates_ReturnsOnlyVisibleTemplates()
        {
            // Arrange
            var templates = new List<DIAGRAM_TEMPLATES>
            {
                new DIAGRAM_TEMPLATES
                {
                    Id = 1,
                    Template_Name = "Visible Template",
                    Image_Source = "template1.png",
                    Diagram_Markup = "<xml>template1</xml>",
                    Is_Visible = true
                },
                new DIAGRAM_TEMPLATES
                {
                    Id = 2,
                    Template_Name = "Hidden Template",
                    Image_Source = "template2.png",
                    Diagram_Markup = "<xml>template2</xml>",
                    Is_Visible = false
                },
                new DIAGRAM_TEMPLATES
                {
                    Id = 3,
                    Template_Name = "Another Visible",
                    Image_Source = "template3.png",
                    Diagram_Markup = "<xml>template3</xml>",
                    Is_Visible = true
                }
            };

            var mockTemplateSet = CreateMockDbSet(templates);
            _mockContext.Setup(c => c.DIAGRAM_TEMPLATES).Returns(mockTemplateSet.Object);

            // Act
            var result = _diagramManager.GetDiagramTemplates().ToList();

            // Assert
            Assert.NotNull(result);
            Assert.Equal(2, result.Count);
            Assert.All(result, t => Assert.NotNull(t.Name));
            Assert.DoesNotContain(result, t => t.Name == "Hidden Template");
        }

        [Fact]
        public void GetDiagramTemplates_ReturnsEmpty_WhenNoVisibleTemplates()
        {
            // Arrange
            var templates = new List<DIAGRAM_TEMPLATES>
            {
                new DIAGRAM_TEMPLATES
                {
                    Id = 1,
                    Template_Name = "Hidden Template",
                    Is_Visible = false
                }
            };

            var mockTemplateSet = CreateMockDbSet(templates);
            _mockContext.Setup(c => c.DIAGRAM_TEMPLATES).Returns(mockTemplateSet.Object);

            // Act
            var result = _diagramManager.GetDiagramTemplates().ToList();

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

            return mockSet;
        }

        public void Dispose()
        {
            // Cleanup if needed
        }
    }
}
