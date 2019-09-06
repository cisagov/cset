using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.Analysis;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
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
        private static readonly object _object = new object();        
        private List<COMPONENT_SYMBOLS> componentSymbols;

        //I don't like this here 
        //I'm not sure why but need to look at it
        private Diagram oldDiagram = new Diagram();
        private Diagram newDiagram = new Diagram();


        /// <summary>
        /// Constructor.
        /// </summary>
        public DiagramDifferenceManager(CSET_Context context)
        {
            this.context = context;
            this.componentSymbols = this.context.COMPONENT_SYMBOLS.ToList();
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
            newDiagram.NetworkComponents = ProcessDiagram(newDiagramDocument);
            oldDiagram.NetworkComponents = ProcessDiagram(oldDiagramDocument);
            findLayersAndZones(newDiagramDocument, newDiagram);
            findLayersAndZones(oldDiagramDocument, oldDiagram);
        }

        public void SaveDifferences(int assessment_id)
        {
            bool _lockTaken = false;
            Monitor.Enter(_object, ref _lockTaken);
            try
            {
                lock (_object)
                {
                    ///when saving if the parent object is a layer then there is not default zone
                    ///if the parent object is zone then all objects in that zone inherit the layer of the zone            
                    DiagramDifferences differences = new DiagramDifferences();
                    differences.processComparison(newDiagram, oldDiagram);
                    foreach (var newNode in differences.AddedNodes)
                    {
                        context.ASSESSMENT_DIAGRAM_COMPONENTS.Add(new ASSESSMENT_DIAGRAM_COMPONENTS()
                        {
                            Assessment_Id = assessment_id,
                            Component_Id = newNode.Key,
                            Diagram_Component_Type = newNode.Value.ComponentType,
                            DrawIO_id = newNode.Value.ID,
                            label = newNode.Value.ComponentName
                        });
                    }
                    context.SaveChanges();

                    foreach (var deleteNode in differences.DeletedNodes)
                    {
                        var adc = context.ASSESSMENT_DIAGRAM_COMPONENTS
                            .FirstOrDefault(x => x.Assessment_Id == assessment_id && x.Component_Id == deleteNode.Key);
                        if (adc != null)
                        {
                            context.ASSESSMENT_DIAGRAM_COMPONENTS.Remove(adc);
                        }
                    }
                    context.SaveChanges();
                    context.FillNetworkDiagramQuestions(assessment_id);
                }
            }
            finally
            {
                System.Threading.Monitor.Exit(_object);
            }
        }


        private void findLayersAndZones(XmlDocument xDoc, Diagram diagram)
        {
            /**
             * Go through and find all the layers first
             * then get all the zones
             * finally associate each layer with it's components and zones
             * then associate each zone with it's components
             * post it to an object for saving.
             */
            XmlNodeList mxCellZones = xDoc.SelectNodes("//*[@zone=\"1\"]");
            XmlNodeList mxCellLayers = xDoc.SelectNodes("//*[@parent=\"0\"]");
            foreach (XmlNode layer in mxCellLayers)
            {
                string id = layer.Attributes["id"].Value;
                diagram.Layers.Add(id, new NetworkLayer()
                {
                    ID = id,
                    LayerName = layer.Attributes["value"] != null ? layer.Attributes["value"].Value : "Main Layer",
                    Visible = layer.Attributes["visible"] != null ? (layer.Attributes["visible"].Value == "0" ? false : true) : true
                });
            }
            foreach (XmlNode zone in mxCellZones)
            {
                string id = zone.Attributes["id"].Value;
                string layerid = zone.FirstChild.Attributes["parent"].Value;
                diagram.Zones.Add(id, new NetworkZone()
                {
                    ID = id,
                    LayerId = layerid,
                    ZoneType = zone.Attributes["zoneType"].Value,
                    SAL = zone.Attributes["SAL"].Value
                });
                XmlNodeList objectNodes = xDoc.SelectNodes("/mxGraphModel/root/object[(@parent=\""+id+"\")]");
                Dictionary<Guid, NetworkComponent> zoneComponents = processNodes(objectNodes);
                foreach (NetworkComponent c in zoneComponents.Values)
                    diagram.Zones[id].ContainingComponents.Add(c);
            }            
        }

        private Dictionary<Guid, NetworkComponent> processNodes(XmlNodeList cells)
        {
            Dictionary<Guid, NetworkComponent> nodesList = new Dictionary<Guid, NetworkComponent>();
            foreach (var c in cells)
            {
                var cell = (XmlElement)c;
                if (cell.HasAttribute("ComponentGuid"))
                {
                    //this seems problematic in that a component could be missing a type
                    NetworkComponent cn = new NetworkComponent();
                    foreach (XmlAttribute a in cell.Attributes)
                    {
                        cn.setValue(a.Name, a.Value);
                    }

                    // determine the component type
                    string ctype = GetComponentType(cell);
                    if(ctype!=null)
                        cn.ComponentType =  ctype;

                    nodesList.Add(cn.ComponentGuid, cn);
                }
            }
            return nodesList;
        }


        private Dictionary<Guid, NetworkComponent> ProcessDiagram(XmlDocument doc)
        {   
            XmlNodeList cells = doc.SelectNodes("/mxGraphModel/root/object");
            return processNodes(cells);
        }


        /// <summary>
        /// Determines component type from its image.
        /// </summary>
        /// <param name="cell"></param>
        /// <returns></returns>
        private string GetComponentType(XmlElement cell)
        {
            var mxCell = cell.SelectSingleNode("mxCell");
            if (mxCell == null)
            {
                return null;
            }

            if (mxCell.Attributes["style"] == null)
            {
                return null;
            }

            string style = mxCell.Attributes["style"].InnerText;
            string[] styleElements = style.Split(';');
            foreach (string styleElement in styleElements)
            {
                if (styleElement.StartsWith("image="))
                {
                    string imagePath = styleElement.Substring("image=".Length);
                    var symbol = this.componentSymbols.FirstOrDefault(x => x.File_Name.EndsWith(imagePath.Substring(imagePath.LastIndexOf('/') + 1)));
                    if (symbol != null)
                    {
                        return symbol.Diagram_Type_Xml;
                    }
                }
            }

            return null;
        }
    }
}

