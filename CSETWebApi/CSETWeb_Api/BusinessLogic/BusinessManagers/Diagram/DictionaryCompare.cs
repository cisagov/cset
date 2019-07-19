using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram
{
    public class DictionaryCompare
    {
        public Dictionary<Guid,string> AddedNodes { get; set; }
        public Dictionary<Guid, string> DeletedNodes { get; set; }
        public DictionaryCompare()
        {
            AddedNodes = new Dictionary<Guid, string>();
            DeletedNodes = new Dictionary<Guid, string>();
        }

        /// <summary>
        /// Look through the properties of the Dictionaries and check to see what was added or removed from the dictionaries
        /// </summary>
        /// <param name="newDiagram"></param>
        /// <param name="oldDiagram"></param>
        public void processComparison(Dictionary<Guid,string> newDiagram, Dictionary<Guid,string> oldDiagram)
        {
            foreach (Guid g in oldDiagram.Keys)
            {
                string ignoreme = null;
                if(!newDiagram.TryGetValue(g,out ignoreme))
                {                    
                    DeletedNodes.Add(g,ignoreme);
                }                
            }
            foreach (Guid g in newDiagram.Keys)
            {
                string ignoreme = null;
                if (!oldDiagram.TryGetValue(g, out ignoreme))
                {
                    AddedNodes.Add(g, ignoreme);
                }               
            }
        }
    }
}
