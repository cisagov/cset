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
            newDiagram.OldParentIds = getParentIdsDictionary(oldDiagramDocument.SelectNodes("/mxGraphModel/root/object"));

            newDiagram.Parentage = BuildParentage(newDiagramDocument);

            newDiagram.NetworkComponents = ProcessDiagram(newDiagramDocument);
            oldDiagram.NetworkComponents = ProcessDiagram(oldDiagramDocument);
            findLayersAndZones(newDiagramDocument, newDiagram);
            findLayersAndZones(oldDiagramDocument, oldDiagram);
            processNodeParentChanges(newDiagram);
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
                            .FirstOrDefault(x => x.Assessment_Id == assessment_id && x.Component_Id == deleteNode.Key);
                        if (adc != null)
                        {
                            context.ASSESSMENT_DIAGRAM_COMPONENTS.Remove(adc);
                        }
                    }                    
                    foreach(var layer in differences.DeletedLayers)
                    {
                        var adc = context.DIAGRAM_CONTAINER.FirstOrDefault(x=> x.Assessment_Id == assessment_id && x.DrawIO_id == layer.Key);
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
                    
                    foreach(var layer in differences.AddedLayers)
                    {
                        var l = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id && x.DrawIO_id == layer.Key).FirstOrDefault();
                        if (l == null) {
                            context.DIAGRAM_CONTAINER.Add(new DIAGRAM_CONTAINER()
                             {
                                 Assessment_Id = assessment_id,
                                 ContainerType = "Layer",
                                 DrawIO_id = layer.Key,
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
                    foreach(var layer in newDiagram.Layers)
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
                    foreach (var zone in differences.AddedZones)
                    {
                        var z = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id && x.DrawIO_id == zone.Key).FirstOrDefault();
                        if (z == null)
                        {
                            z = new DIAGRAM_CONTAINER()
                            {
                                Assessment_Id = assessment_id,
                                ContainerType = "Zone",
                                DrawIO_id = zone.Key,
                                Name = zone.Value.ComponentName,
                                Universal_Sal_Level = zone.Value.SAL,
                                Parent_Id = layerLookup[zone.Value.Parent_id]
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

                    Dictionary<string, int> zLookup = context.DIAGRAM_CONTAINER.Where(x=> x.Assessment_Id == assessment_id && x.ContainerType == "Zone").ToList().ToDictionary(x => x.DrawIO_id, x => x.Container_Id);
                    Dictionary<int, int> containerLookup = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id).ToList().ToDictionary(x => x.Container_Id, x => x.Parent_Id);
                    Dictionary<string, int> allItems = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id).ToList().ToDictionary(x => x.DrawIO_id, x => x.Container_Id);



                    foreach (var newNode in differences.AddedNodes)
                    {
                        int zone_id, layer_id =0;
                        bool zIsNull = false;
                        zIsNull = !zLookup.TryGetValue(newNode.Value.Parent_id, out zone_id);
                        
                        layer_id = GetLayerId(newNode.Value.ID, newDiagram.Parentage, allItems);
                        

                        context.ASSESSMENT_DIAGRAM_COMPONENTS.Add(new ASSESSMENT_DIAGRAM_COMPONENTS()
                        {
                            Assessment_Id = assessment_id,
                            Component_Id = newNode.Key,
                            Diagram_Component_Type = newNode.Value.ComponentType,
                            DrawIO_id = newNode.Value.ID,
                            label = newNode.Value.ComponentName, 
                            Layer_Id = (int?) layer_id,
                            Zone_Id = zIsNull? null: (int?) zone_id
                        });
                    }
                    context.SaveChanges();

                    foreach(var node in newDiagram.getParentChanges())
                    {

                        //find the new parent zone or layer and set it
                        var n = context.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.Assessment_Id == assessment_id && x.DrawIO_id == node.ID).FirstOrDefault();
                        if (n != null)
                        {

                            int layer_id = GetLayerId(node.ID, newDiagram.Parentage, allItems);
                            //try zone first if it is zone then the component gets the zone's layer
                            //then try layer
                            //then assume we are broken
                            int parent_id; 
                            if(zLookup.TryGetValue(node.Parent_id,out parent_id))
                            {
                                n.Zone_Id = parent_id;
                                n.Layer_Id = layer_id;
                            }
                            else
                            {
                                n.Layer_Id = layer_id;
                            }
                        }                        
                    }
                    foreach (var node in newDiagram.getParentChangesZones())
                    {
                        //find the new parent zone or layer and set it
                        var n = context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessment_id && x.DrawIO_id == node.ID).FirstOrDefault();
                        if (n != null)
                        {
                            // recurse parentage upward until we find one that we recognize in allItems
                            string id = n.DrawIO_id;
                            while (newDiagram.Parentage.ContainsKey(id))
                            {
                                id = newDiagram.Parentage[id];
                                if (allItems.ContainsKey(id))
                                {
                                    break;
                                }
                            }

                            n.Parent_Id = allItems[id];
                        }
                    }
                    context.SaveChanges();
                    context.FillNetworkDiagramQuestions(assessment_id);
                }
            }
            catch(Exception e)
            {
                throw e;
            }
            finally
            {
                System.Threading.Monitor.Exit(_object);
            }
        }


        /// <summary>
        /// Returns the DB identity of the layer that the component lives in.
        /// </summary>
        /// <returns></returns>
        private int GetLayerId(string id, Dictionary<string, string> parentage, Dictionary<string, int> allItems)
        {
            while (parentage.ContainsKey(id) && parentage[id] != "0")
            {
                id = parentage[id];
            }

            // return the identity ID of the layer we just found
            return allItems[id];
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
                    Parent_id = layerid,
                    ZoneType = zone.Attributes["zoneType"].Value,
                    SAL = zone.Attributes["SAL"].Value,
                    ComponentName = zone.Attributes["label"].Value
                });
                XmlNodeList objectNodes = xDoc.SelectNodes("/mxGraphModel/root/object[(@parent=\""+id+"\")]");
                //Dictionary<Guid, NetworkComponent> zoneComponents = processNodes(objectNodes);
                //foreach (NetworkComponent c in zoneComponents.Values)
                //    diagram.Zones[id].ContainingComponents.Add(c);
            }            
        }

        

        /**
         * Before processing the network nodes get a list of all the previous dictionary
         * id's if the parent id has changed then mark this as having moved. 
         * The moved items will need to be connected to their new parents once 
         * all of the layers and zones have been created and dealt with.
         */
        private Dictionary<string, string> getParentIdsDictionary(XmlNodeList cells)
        {
            Dictionary<string, string> nodesList = new Dictionary<string,string>();
            foreach (var c in cells)
            {
                var cell = (XmlElement)c;
                if (cell.HasAttribute("id"))
                {
                    string id = cell.GetAttribute("id");
                    string parent_id = GetParentId(cell);
                    nodesList.Add(id,parent_id);
                }
            }
            return nodesList;
        }

        private void processNodeParentChanges(Diagram newDiagram)
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

                    cn.Parent_id = GetParentId(cell);

                    // determine the component type
                    string ctype = GetComponentType(cell);
                    if(ctype!=null)
                        cn.ComponentType =  ctype;

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

