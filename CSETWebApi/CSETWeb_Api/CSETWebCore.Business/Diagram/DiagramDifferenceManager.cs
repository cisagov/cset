//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Xml;
using CSETWebCore.Business.Diagram.layers;
using CSETWebCore.Constants;

namespace CSETWebCore.Business.Diagram
{
    /// <summary>
    /// this is the main entry point for 
    /// diagram changes and differences
    /// </summary>
    public class DiagramDifferenceManager
    {
        private const string CONTAINER_TYPE_LAYER = "Layer";
        private CSETContext context;
        private List<COMPONENT_SYMBOLS> componentSymbols;

        //I don't like this here 
        //I'm not sure why but need to look at it
        private Diagram oldDiagram = new Diagram();
        private Diagram newDiagram = new Diagram();


        /// <summary>
        /// Constructor.
        /// </summary>
        public DiagramDifferenceManager(CSETContext context)
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
        public void BuildDiagramDictionaries(XmlDocument newDiagramDocument, XmlDocument oldDiagramDocument)
        {
            var nodeList1 = oldDiagramDocument.SelectNodes("/mxGraphModel/root/object | /mxGraphModel/root/UserObject");
            var nodeList2 = oldDiagramDocument.SelectNodes("/mxGraphModel/root/UserObject");

            //var nodeList = (XmlNodeList)nodeList1.Cast<XmlNode>().Concat<XmlNode>(nodeList2.Cast<XmlNode>());

            newDiagram.OldParentIds = GetParentIdsDictionary(nodeList1);

            newDiagram.Parentage = BuildParentage(newDiagramDocument);

            newDiagram.NetworkComponents = ProcessDiagram(newDiagramDocument);
            oldDiagram.NetworkComponents = ProcessDiagram(oldDiagramDocument);
            FindLayersAndZones(newDiagramDocument, newDiagram);
            FindLayersAndZones(oldDiagramDocument, oldDiagram);
            ProcessNodeParentChanges(newDiagram);
        }


        public void SaveDifferences(int assessment_id, bool refreshQuestions)
        {
            ///when saving if the parent object is a layer then there is not default zone
            ///if the parent object is zone then all objects in that zone inherit the layer of the zone            

            /*
             * remove all deleted zones and layers
             * remove 
             * add in all the layers and zones
             * add all the components for each layer and zone
             * 
             */
            DiagramDifferences differences = new DiagramDifferences();
            differences.processComparison(newDiagram, oldDiagram);

            foreach (var deleteNode in differences.DeletedNodes)
            {
                var adc = context.ASSESSMENT_DIAGRAM_COMPONENTS
                    .FirstOrDefault(x => x.Assessment_Id == assessment_id && x.Component_Guid == deleteNode.Key);
                if (adc != null)
                {
                    context.ASSESSMENT_DIAGRAM_COMPONENTS.Remove(adc);
                }
            }
            foreach (var layer in differences.DeletedLayers)
            {
                var adc = context.DIAGRAM_CONTAINER.FirstOrDefault(x => x.Assessment_Id == assessment_id && x.DrawIO_id == layer.Key);
                if (adc != null)
                {
                    context.DIAGRAM_CONTAINER.Remove(adc);
                }
            }
            foreach (var zone in differences.DeletedZones)
            {
                var adc = context.DIAGRAM_CONTAINER.FirstOrDefault(x => x.Assessment_Id == assessment_id && x.DrawIO_id == zone.Key);
                if (adc != null)
                {
                    context.DIAGRAM_CONTAINER.Remove(adc);
                }
            }

            foreach (var layer in differences.AddedContainers)
            {
                var l = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id && x.DrawIO_id == layer.Key).FirstOrDefault();
                if (l == null)
                {
                    context.DIAGRAM_CONTAINER.Add(new DIAGRAM_CONTAINER()
                    {
                        Assessment_Id = assessment_id,
                        ContainerType = CONTAINER_TYPE_LAYER,
                        DrawIO_id = layer.Key,
                        Parent_Draw_IO_Id = layer.Value.Parent_id,
                        Name = layer.Value.LayerName,
                        Visible = layer.Value.Visible
                    });
                }
                else
                {
                    l.Name = layer.Value.LayerName;
                    l.Visible = layer.Value.Visible;

                }
            }
            //case were the only change was a layer visibility change
            foreach (var layer in newDiagram.Layers)
            {
                var l = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id && x.DrawIO_id == layer.Key).FirstOrDefault();
                if (l != null)
                {
                    l.Name = layer.Value.LayerName;
                    l.Visible = layer.Value.Visible;
                }
            }

            context.SaveChanges();
            Dictionary<string, int> layerLookup = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id).ToList().ToDictionary(x => x.DrawIO_id, x => x.Container_Id);
            int defaultLayer;
            //if we didn't find the default layer then just add it.
            //no sure why we wouldn't but some how that is the case.
            if (!layerLookup.TryGetValue("1", out defaultLayer))
            {
                var layer = new DIAGRAM_CONTAINER()
                {
                    Assessment_Id = assessment_id,
                    ContainerType = CONTAINER_TYPE_LAYER,
                    DrawIO_id = "1",
                    Name = Constants.Constants.DEFAULT_LAYER_NAME,
                    Parent_Id = 0,
                    Parent_Draw_IO_Id = null,
                    Universal_Sal_Level = "L",
                    Visible = true
                };
                context.DIAGRAM_CONTAINER.Add(layer);
                defaultLayer = layer.Container_Id;
            }

            foreach (var zone in newDiagram.Zones)
            {
                var z = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id && x.DrawIO_id == zone.Key).FirstOrDefault();
                if (z == null)
                {
                    if (!layerLookup.TryGetValue(zone.Value.Parent_id, out int parent_id))
                    {
                        parent_id = defaultLayer;
                    }
                    z = new DIAGRAM_CONTAINER()
                    {
                        Assessment_Id = assessment_id,
                        ContainerType = "Zone",
                        DrawIO_id = zone.Key,
                        Name = zone.Value.ComponentName,
                        Universal_Sal_Level = zone.Value.SAL,
                        Parent_Id = parent_id,
                        Parent_Draw_IO_Id = zone.Value.Parent_id
                    };
                    context.DIAGRAM_CONTAINER.Add(z);

                }
                else
                {
                    z.Universal_Sal_Level = zone.Value.SAL;
                    z.Name = zone.Value.ComponentName;
                }
            }
            context.SaveChanges();

            LayerManager layers = new LayerManager(context, assessment_id);
            Dictionary<Guid, ASSESSMENT_DIAGRAM_COMPONENTS> adcDictionary = context.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.Assessment_Id == assessment_id).ToDictionary(x => x.Component_Guid, x => x);
            foreach (var newNode in newDiagram.NetworkComponents)
            {
                ASSESSMENT_DIAGRAM_COMPONENTS adc;
                if (adcDictionary.TryGetValue(newNode.Key, out adc))
                {
                    adc.Assessment_Id = assessment_id;
                    adc.Component_Guid = newNode.Key;
                    adc.Component_Symbol_Id = newNode.Value.Component_Symbol_Id;
                    adc.DrawIO_id = newNode.Value.ID;
                    adc.Parent_DrawIO_Id = newNode.Value.Parent_id;
                    adc.label = newNode.Value.ComponentName;
                }
                else
                {

                    adc = new ASSESSMENT_DIAGRAM_COMPONENTS()
                    {
                        Assessment_Id = assessment_id,
                        Component_Guid = newNode.Key,
                        Component_Symbol_Id = newNode.Value.Component_Symbol_Id,
                        DrawIO_id = newNode.Value.ID,
                        Parent_DrawIO_Id = newNode.Value.Parent_id,
                        label = newNode.Value.ComponentName,
                        Layer_Id = null,
                        Zone_Id = null
                    };
                    context.ASSESSMENT_DIAGRAM_COMPONENTS.Add(adc);
                }
            }
            context.SaveChanges();


            //tossing the whole approach and doing something different
            //save all containers, layers, and nodes
            //then go find and assign zone and layer
            var updateList = from a in context.ASSESSMENT_DIAGRAM_COMPONENTS select a;
            //join b in newDiagram.NetworkComponents on a.Component_Guid equals b.Key
            //select new { a, b };
            var updateListPair = from a in updateList.ToList()
                                 join b in newDiagram.NetworkComponents on a.Component_Guid equals b.Key
                                 select new { a, b };
            foreach (var pair in updateListPair.ToList())
            {
                pair.a.Component_Symbol_Id = pair.b.Value.Component_Symbol_Id;
                pair.a.label = pair.b.Value.ComponentName;
            }
            context.SaveChanges();
            layers.UpdateAllLayersAndZones();

            if (refreshQuestions)
            {
                context.FillNetworkDiagramQuestions(assessment_id);
            }
        }


        private void FindLayersAndZones(XmlDocument xDoc, Diagram diagram)
        {
            /**
             * Go through and find all the layers first
             * then get all the zones
             * finally associate each layer with it's components and zones
             * then associate each zone with it's components
             * post it to an object for saving.
             */
            XmlNodeList mxCellZones = xDoc.SelectNodes("//*[@zone=\"1\"]");
            XmlNodeList mxCellLayers = xDoc.SelectNodes("//*[@parent=\"0\" and @id]");
            foreach (XmlNode layer in mxCellLayers)
            {
                string id = layer.Attributes["id"].Value;
                diagram.Layers.Add(id, new NetworkLayer()
                {
                    ID = id,
                    LayerName = layer.Attributes["value"] != null ? layer.Attributes["value"].Value : Constants.Constants.DEFAULT_LAYER_NAME,
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
                    Parent_id = layerid,
                    ZoneType = zone.Attributes["ZoneType"].Value,
                    SAL = zone.Attributes["SAL"].Value,
                    ComponentName = zone.Attributes["label"].Value
                });

                string myxpath1 = "/mxGraphModel/root/object/mxCell[(@parent=\"" + id + "\")]/.."
                    + " | "
                    + "/mxGraphModel/root/UserObject/mxCell[(@parent=\"" + id + "\")]/..";
                XmlNodeList objectNodes1 = xDoc.SelectNodes(myxpath1);
                //string myxpath2 = "/mxGraphModel/root/UserObject/mxCell[(@parent=\"" + id + "\")]/..";
                //XmlNodeList objectNodes2 = xDoc.SelectNodes(myxpath2);

                //var objectNodes = objectNodes1.Cast<XmlNode>().Concat<XmlNode>(objectNodes2.Cast<XmlNode>());

                Dictionary<Guid, NetworkComponent> zoneComponents = ProcessNodes((XmlNodeList)objectNodes1);

                foreach (NetworkComponent c in zoneComponents.Values)
                    diagram.Zones[id].ContainingComponents.Add(c);
            }
        }


        /**
         * Before processing the network nodes get a list of all the previous dictionary
         * id's if the parent id has changed then mark this as having moved. 
         * The moved items will need to be connected to their new parents once 
         * all of the layers and zones have been created and dealt with.
         */
        private Dictionary<string, string> GetParentIdsDictionary(XmlNodeList cells)
        {
            Dictionary<string, string> nodesList = new Dictionary<string, string>();
            foreach (var c in cells)
            {
                var cell = (XmlElement)c;
                if (cell.HasAttribute("id"))
                {
                    string id = cell.GetAttribute("id");
                    string parent_id = GetParentId(cell);
                    nodesList.Add(id, parent_id);
                }
            }
            return nodesList;
        }


        private void ProcessNodeParentChanges(Diagram newDiagram)
        {
            List<NetworkNode> networkNodes = newDiagram.NetworkComponents.Values.Cast<NetworkNode>().ToList();
            IdentifyComponentLayerZoneChanges(networkNodes, newDiagram.OldParentIds);
            IdentifyComponentLayerZoneChanges(newDiagram.Zones.Values.Cast<NetworkNode>().ToList(), newDiagram.OldParentIds);
        }


        /// <summary>
        /// this needs to be all zones and components
        /// </summary>
        /// <param name="nodesList"></param>
        private void IdentifyComponentLayerZoneChanges(List<NetworkNode> nodesList, Dictionary<string, string> parents)
        {
            foreach (var c in nodesList)
            {
                string oldParent;
                if (parents.TryGetValue(c.ID, out oldParent))
                {
                    c.ParentChanged = c.Parent_id != oldParent;
                }
                else
                {
                    c.ParentChanged = true;
                }
            }
        }


        /// <summary>
        /// Returns a dictionary where the key is the DrawIO ID and the value is its parent ID.
        /// </summary>
        /// <param name="doc"></param>
        /// <returns></returns>
        private Dictionary<string, string> BuildParentage(XmlDocument doc)
        {
            // key = id, value = parent
            var dict = new Dictionary<string, string>();
            var objList = doc.SelectNodes("//*[@id]");
            foreach (XmlNode n in objList)
            {
                if (n.Attributes["parent"] != null)
                {
                    dict.Add(n.Attributes["id"].InnerText, n.Attributes["parent"].InnerText);
                    continue;
                }

                // Sometimes the id and parent attributes are on different elements.  
                // Look for a child mxCell.
                var c = n.SelectSingleNode("mxCell");
                if (c != null)
                {
                    dict.Add(n.Attributes["id"].InnerText, c.Attributes["parent"].InnerText);
                }
            }

            return dict;
        }


        private Dictionary<Guid, NetworkComponent> ProcessNodes(XmlNodeList cells)
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
                        cn.SetValue(a.Name, a.Value);
                    }

                    cn.Parent_id = GetParentId(cell);

                    // determine the component type
                    int ctype = GetComponentType(cell);
                    if (ctype != 0)
                    {
                        cn.Component_Symbol_Id = ctype;
                    }
                    else
                    {
                        throw new Exception("Unrecognized component: " + cell.OuterXml);
                    }
                    NetworkComponent tmp;
                    if (nodesList.TryGetValue(cn.ComponentGuid, out tmp))
                    {
                        if (cn.Equals(tmp))
                        {
                            Trace.WriteLine("cn == temp");
                        }
                    }
                    else
                        nodesList.Add(cn.ComponentGuid, cn);
                }
            }
            return nodesList;
        }


        private string GetParentId(XmlElement cell)
        {
            var mxCell = cell.SelectSingleNode("mxCell");
            if (mxCell == null)
            {
                return null;
            }

            if (mxCell.Attributes["parent"] == null)
            {
                return null;
            }
            return mxCell.Attributes["parent"].Value;
        }


        private Dictionary<Guid, NetworkComponent> ProcessDiagram(XmlDocument doc)
        {
            XmlNodeList cells1 = doc.SelectNodes("/mxGraphModel/root/object[not(mxCell[@parent=0])] | /mxGraphModel/root/UserObject[not(mxCell[@parent=0])]");
            //XmlNodeList cells2 = doc.SelectNodes("/mxGraphModel/root/UserObject[not(mxCell[@parent=0])]");

            //var cells = (XmlNodeList)cells1.Cast<XmlNode>().Concat<XmlNode>(cells1.Cast<XmlNode>());

            return ProcessNodes(cells1);
        }


        /// <summary>
        /// Determines component type from its image or other attributes.
        /// </summary>
        /// <param name="cell"></param>
        /// <returns></returns>
        private int GetComponentType(XmlElement cell)
        {
            var mxCell = cell.SelectSingleNode("mxCell");
            if (mxCell == null)
            {
                return 0;
            }

            if (mxCell.Attributes["style"] == null)
            {
                return 0;
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
                        return symbol.Component_Symbol_Id;
                    }
                }

                if (styleElement == "msc=1")
                {
                    var symbol = this.componentSymbols.FirstOrDefault(x => x.Abbreviation == "MSC");
                    if (symbol != null)
                    {
                        return symbol.Component_Symbol_Id;
                    }
                }
            }

            return 0;
        }
    }
}

