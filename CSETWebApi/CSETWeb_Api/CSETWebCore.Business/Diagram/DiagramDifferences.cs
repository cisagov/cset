//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.Analysis;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Business.Diagram
{
    public class DiagramDifferences
    {
        public Dictionary<Guid, NetworkComponent> AddedNodes { get; set; }
        public Dictionary<Guid, NetworkComponent> DeletedNodes { get; set; }
        public Dictionary<string, NetworkLayer> AddedContainers { get; set; }
        public Dictionary<string, NetworkLayer> DeletedLayers { get; set; }
        public Dictionary<string, NetworkZone> DeletedZones { get; set; }

        public DiagramDifferences()
        {
            AddedNodes = new Dictionary<Guid, NetworkComponent>();
            DeletedNodes = new Dictionary<Guid, NetworkComponent>();
        }

        /// <summary>
        /// Look through the properties of the Dictionaries and check to see what was added or removed from the dictionaries
        /// </summary>
        /// <param name="newDiagram"></param>
        /// <param name="oldDiagram"></param>
        public void processComparison(Diagram newDiagram, Diagram oldDiagram)
        {

            this.AddedNodes = lookupValue(newDiagram.NetworkComponents, oldDiagram.NetworkComponents);
            this.DeletedNodes = lookupValue(oldDiagram.NetworkComponents, newDiagram.NetworkComponents);
            this.AddedContainers = processLayers(newDiagram.Layers, oldDiagram.Layers);
            this.DeletedLayers = processLayers(oldDiagram.Layers, newDiagram.Layers);
            this.DeletedZones = processZones(oldDiagram.Zones, newDiagram.Zones);
        }

        private Dictionary<string, NetworkZone> processZones(Dictionary<string, NetworkZone> sourcedictionary, Dictionary<string, NetworkZone> destinationDictionary)
        {
            Dictionary<string, NetworkZone> differences = new Dictionary<string, NetworkZone>();
            foreach (KeyValuePair<string, NetworkZone> g in sourcedictionary)
            {
                NetworkZone ignoreme = null;
                if (!destinationDictionary.TryGetValue(g.Key, out ignoreme))
                {
                    differences.Add(g.Key, g.Value);
                }
            }
            return differences;
        }

        private Dictionary<string, NetworkLayer> processLayers(Dictionary<string, NetworkLayer> sourcedictionary, Dictionary<string, NetworkLayer> destinationDictionary)
        {
            Dictionary<string, NetworkLayer> differences = new Dictionary<string, NetworkLayer>();
            foreach (KeyValuePair<string, NetworkLayer> g in sourcedictionary)
            {
                NetworkLayer ignoreme = null;
                if (!destinationDictionary.TryGetValue(g.Key, out ignoreme))
                {
                    differences.Add(g.Key, g.Value);
                }
            }
            return differences;
        }

        private Dictionary<Guid, NetworkComponent> lookupValue(Dictionary<Guid, NetworkComponent> sourcedictionary, Dictionary<Guid, NetworkComponent> destinationDictionary)
        {
            Dictionary<Guid, NetworkComponent> differences = new Dictionary<Guid, NetworkComponent>();
            foreach (KeyValuePair<Guid, NetworkComponent> g in sourcedictionary)
            {
                NetworkComponent ignoreme = null;
                if (!destinationDictionary.TryGetValue(g.Key, out ignoreme))
                {
                    differences.Add(g.Key, g.Value);
                }
            }
            return differences;
        }
    }
}
