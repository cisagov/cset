using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram
{
    /// <summary>
    /// this is the main entry point for 
    /// diagram changes and differences
    /// </summary>
    public class DiagramDifferenceManager
    {
        private CSET_Context context;

        DiagramDifferenceManager(CSET_Context context)
        {
            this.context = context;
        }
        
        /// <summary>
        /// pass in the xml document
        /// get the existing from the database
        /// create the dictionaries 
        /// call the diff extractor
        /// get back the adds and deletes
        /// add records to the table for the new components
        /// deleted records for the removed components
        /// </summary>
        public void buildDiagramDictionaries(XmlDocument newDiagramDocument, XmlDocument oldDiagramDocument)
        {
            Dictionary<Guid, ComponentNode> OldDiagram = new Dictionary<Guid, ComponentNode>();
            Dictionary<Guid, ComponentNode> NewDiagram = new Dictionary<Guid, ComponentNode>();

            NewDiagram = processDiagram(newDiagramDocument);
            OldDiagram = processDiagram(oldDiagramDocument);
        }

        private void saveDifferences(Dictionary<Guid, ComponentNode> OldDiagram, Dictionary<Guid, ComponentNode> NewDiagram)
        {
            DiagramDifferences differences = new DiagramDifferences();
            differences.processComparison(NewDiagram, OldDiagram);
            foreach(var newNode in differences.AddedNodes)
            {
                //context.ASSESSMENT_DIAGRAM_COMPONENTS.Add(new ASSESSMENT_DIAGRAM_COMPONENTS()
                //{
                //    Assessment_Id
                //});
            }
        }

        private Dictionary<Guid,ComponentNode> processDiagram(XmlDocument doc)
        {
            Dictionary<Guid, ComponentNode> nodesList = new Dictionary<Guid, ComponentNode>(); 
            XmlNodeList cells = doc.SelectNodes("/mxGraphModel/root/object");
            foreach (var c in cells)
            {
                ComponentNode cn = new ComponentNode();
                foreach(XmlAttribute a in ((System.Xml.XmlElement)c).Attributes)
                {
                    cn.setValue(a.Name, a.Value);                    
                }
                nodesList.Add(cn.ComponentGuid,cn);                
            }
            return nodesList;
        }
    }

    public class ComponentNode
    {
        public string label { get; set; }
        public Guid ComponentGuid { get; set; }
        public string id { get; set; }

        public void setValue(string name, string value)
        {
            switch (name)
            {
                case "label":
                    this.label = value;
                    break;
                case "ComponentGuid":
                    this.ComponentGuid = new Guid(value);
                    break;
                case "id":
                    this.id = value;
                    break;
            }
        }
    }
}

