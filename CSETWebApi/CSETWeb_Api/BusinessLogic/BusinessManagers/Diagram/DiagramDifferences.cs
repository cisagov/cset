using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram
{
    public class DiagramDifferences
    {
        public Dictionary<Guid,ComponentNode> AddedNodes { get; set; }
        public Dictionary<Guid,ComponentNode> DeletedNodes { get; set; }
        public DiagramDifferences()
        {
            AddedNodes = new Dictionary<Guid,ComponentNode>();
            DeletedNodes = new Dictionary<Guid,ComponentNode>();
        }

        /// <summary>
        /// Look through the properties of the Dictionaries and check to see what was added or removed from the dictionaries
        /// </summary>
        /// <param name="newDiagram"></param>
        /// <param name="oldDiagram"></param>
        public void processComparison(Dictionary<Guid,ComponentNode> newDiagram, Dictionary<Guid,ComponentNode> oldDiagram)
        {
            this.AddedNodes = lookupValue(newDiagram, oldDiagram);
            this.DeletedNodes = lookupValue(oldDiagram, newDiagram);
            
        }

        private Dictionary<Guid,ComponentNode> lookupValue(Dictionary<Guid,ComponentNode> sourcedictionary, Dictionary<Guid,ComponentNode> destinationDictionary)
        {
            Dictionary<Guid, ComponentNode> differences = new Dictionary<Guid, ComponentNode>();
            foreach (KeyValuePair<Guid,ComponentNode> g in sourcedictionary)
            {
                ComponentNode ignoreme = null;
                if (!destinationDictionary.TryGetValue(g.Key, out ignoreme))
                {
                    differences.Add(g.Key, g.Value);
                }
            }
            return differences;
        }
    }
}
