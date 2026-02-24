////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Business.Diagram;
using CSETWebCore.Business.Diagram.Analysis;

namespace CSETWebCore.Business.Tests.Diagram
{
    /// <summary>
    /// Unit tests for DiagramDifferences class.
    /// Tests diagram comparison logic for detecting added/deleted nodes, layers, and zones.
    /// </summary>
    public class DiagramDifferencesTests
    {
        [Fact]
        public void ProcessComparison_DetectsAddedNodes()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            var nodeGuid = Guid.NewGuid();
            var newComponent = new NetworkComponent();
            newComponent.SetValue("ComponentGuid", nodeGuid.ToString());
            newComponent.SetValue("label", "New Component");
            newDiagram.NetworkComponents.Add(nodeGuid, newComponent);

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Single(differences.AddedNodes);
            Assert.Contains(nodeGuid, differences.AddedNodes.Keys);
            Assert.Empty(differences.DeletedNodes);
        }

        [Fact]
        public void ProcessComparison_DetectsDeletedNodes()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            var nodeGuid = Guid.NewGuid();
            var deletedComponent = new NetworkComponent();
            deletedComponent.SetValue("ComponentGuid", nodeGuid.ToString());
            deletedComponent.SetValue("label", "Deleted Component");
            oldDiagram.NetworkComponents.Add(nodeGuid, deletedComponent);

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Single(differences.DeletedNodes);
            Assert.Contains(nodeGuid, differences.DeletedNodes.Keys);
            Assert.Empty(differences.AddedNodes);
        }

        [Fact]
        public void ProcessComparison_DetectsMultipleAddedAndDeletedNodes()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            var addedGuid1 = Guid.NewGuid();
            var addedGuid2 = Guid.NewGuid();
            var deletedGuid1 = Guid.NewGuid();
            var deletedGuid2 = Guid.NewGuid();
            var unchangedGuid = Guid.NewGuid();

            // Added nodes
            var added1 = new NetworkComponent();
            added1.SetValue("ComponentGuid", addedGuid1.ToString());
            newDiagram.NetworkComponents.Add(addedGuid1, added1);

            var added2 = new NetworkComponent();
            added2.SetValue("ComponentGuid", addedGuid2.ToString());
            newDiagram.NetworkComponents.Add(addedGuid2, added2);

            // Deleted nodes
            var deleted1 = new NetworkComponent();
            deleted1.SetValue("ComponentGuid", deletedGuid1.ToString());
            oldDiagram.NetworkComponents.Add(deletedGuid1, deleted1);

            var deleted2 = new NetworkComponent();
            deleted2.SetValue("ComponentGuid", deletedGuid2.ToString());
            oldDiagram.NetworkComponents.Add(deletedGuid2, deleted2);

            // Unchanged node (exists in both)
            var unchanged1 = new NetworkComponent();
            unchanged1.SetValue("ComponentGuid", unchangedGuid.ToString());
            newDiagram.NetworkComponents.Add(unchangedGuid, unchanged1);

            var unchanged2 = new NetworkComponent();
            unchanged2.SetValue("ComponentGuid", unchangedGuid.ToString());
            oldDiagram.NetworkComponents.Add(unchangedGuid, unchanged2);

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Equal(2, differences.AddedNodes.Count);
            Assert.Equal(2, differences.DeletedNodes.Count);
            Assert.Contains(addedGuid1, differences.AddedNodes.Keys);
            Assert.Contains(addedGuid2, differences.AddedNodes.Keys);
            Assert.Contains(deletedGuid1, differences.DeletedNodes.Keys);
            Assert.Contains(deletedGuid2, differences.DeletedNodes.Keys);
            Assert.DoesNotContain(unchangedGuid, differences.AddedNodes.Keys);
            Assert.DoesNotContain(unchangedGuid, differences.DeletedNodes.Keys);
        }

        [Fact]
        public void ProcessComparison_DetectsAddedLayers()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            var layerId = "layer-1";
            newDiagram.Layers.Add(layerId, new NetworkLayer
            {
                ID = layerId,
                LayerName = "New Layer"
            });

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Single(differences.AddedContainers);
            Assert.Contains(layerId, differences.AddedContainers.Keys);
            Assert.Empty(differences.DeletedLayers);
        }

        [Fact]
        public void ProcessComparison_DetectsDeletedLayers()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            var layerId = "layer-1";
            oldDiagram.Layers.Add(layerId, new NetworkLayer
            {
                ID = layerId,
                LayerName = "Deleted Layer"
            });

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Single(differences.DeletedLayers);
            Assert.Contains(layerId, differences.DeletedLayers.Keys);
            Assert.Empty(differences.AddedContainers);
        }

        [Fact]
        public void ProcessComparison_DetectsDeletedZones()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            var zoneId = "zone-1";
            var deletedZone = new NetworkZone();
            deletedZone.ID = zoneId;
            deletedZone.SetValue("label", "Deleted Zone");
            oldDiagram.Zones.Add(zoneId, deletedZone);

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Single(differences.DeletedZones);
            Assert.Contains(zoneId, differences.DeletedZones.Keys);
        }

        [Fact]
        public void ProcessComparison_HandlesEmptyDiagrams()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Empty(differences.AddedNodes);
            Assert.Empty(differences.DeletedNodes);
            Assert.Empty(differences.AddedContainers);
            Assert.Empty(differences.DeletedLayers);
            Assert.Empty(differences.DeletedZones);
        }

        [Fact]
        public void ProcessComparison_DetectsComplexChanges()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            // Add nodes
            var addedNode = Guid.NewGuid();
            var addedComponent = new NetworkComponent();
            addedComponent.SetValue("ComponentGuid", addedNode.ToString());
            newDiagram.NetworkComponents.Add(addedNode, addedComponent);

            // Delete nodes
            var deletedNode = Guid.NewGuid();
            var deletedComponent = new NetworkComponent();
            deletedComponent.SetValue("ComponentGuid", deletedNode.ToString());
            oldDiagram.NetworkComponents.Add(deletedNode, deletedComponent);

            // Add layers
            var addedLayer = "new-layer";
            newDiagram.Layers.Add(addedLayer, new NetworkLayer { ID = addedLayer });

            // Delete layers
            var deletedLayer = "old-layer";
            oldDiagram.Layers.Add(deletedLayer, new NetworkLayer { ID = deletedLayer });

            // Delete zones
            var deletedZone = "old-zone";
            oldDiagram.Zones.Add(deletedZone, new NetworkZone { ID = deletedZone });

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Single(differences.AddedNodes);
            Assert.Single(differences.DeletedNodes);
            Assert.Single(differences.AddedContainers);
            Assert.Single(differences.DeletedLayers);
            Assert.Single(differences.DeletedZones);
        }

        [Fact]
        public void ProcessComparison_IgnoresUnchangedElements()
        {
            // Arrange
            var differences = new DiagramDifferences();
            var newDiagram = new Business.Diagram.Diagram();
            var oldDiagram = new Business.Diagram.Diagram();

            var nodeGuid = Guid.NewGuid();
            var layerId = "layer-1";
            var zoneId = "zone-1";

            // Add same elements to both diagrams
            var newComponent = new NetworkComponent();
            newComponent.SetValue("ComponentGuid", nodeGuid.ToString());
            newDiagram.NetworkComponents.Add(nodeGuid, newComponent);

            var oldComponent = new NetworkComponent();
            oldComponent.SetValue("ComponentGuid", nodeGuid.ToString());
            oldDiagram.NetworkComponents.Add(nodeGuid, oldComponent);

            newDiagram.Layers.Add(layerId, new NetworkLayer { ID = layerId });
            oldDiagram.Layers.Add(layerId, new NetworkLayer { ID = layerId });

            newDiagram.Zones.Add(zoneId, new NetworkZone { ID = zoneId });
            oldDiagram.Zones.Add(zoneId, new NetworkZone { ID = zoneId });

            // Act
            differences.processComparison(newDiagram, oldDiagram);

            // Assert
            Assert.Empty(differences.AddedNodes);
            Assert.Empty(differences.DeletedNodes);
            Assert.Empty(differences.AddedContainers);
            Assert.Empty(differences.DeletedLayers);
            Assert.Empty(differences.DeletedZones);
        }

        [Fact]
        public void Constructor_InitializesEmptyDictionaries()
        {
            // Act
            var differences = new DiagramDifferences();

            // Assert
            Assert.NotNull(differences.AddedNodes);
            Assert.NotNull(differences.DeletedNodes);
            Assert.Empty(differences.AddedNodes);
            Assert.Empty(differences.DeletedNodes);
        }
    }
}
