using CSETWeb_Api.BusinessManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram
{
    public class DiagramDifferences
    {
        public Dictionary<Guid,NetworkComponent> AddedNodes { get; set; }
        public Dictionary<Guid,NetworkComponent> DeletedNodes { get; set; }
        public DiagramDifferences()
        {
            AddedNodes = new Dictionary<Guid,NetworkComponent>();
            DeletedNodes = new Dictionary<Guid,NetworkComponent>();
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
            
        }

        private Dictionary<Guid,NetworkComponent> lookupValue(Dictionary<Guid,NetworkComponent> sourcedictionary, Dictionary<Guid,NetworkComponent> destinationDictionary)
        {
            Dictionary<Guid, NetworkComponent> differences = new Dictionary<Guid, NetworkComponent>();
            foreach (KeyValuePair<Guid,NetworkComponent> g in sourcedictionary)
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
