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
                        var adc = context.DIAGRAM_LAYERS.FirstOrDefault(x=> x.Assessment_Id == assessment_id && x.DrawIO_id == layer.Key);
                        if (adc != null)
                        {
                            context.DIAGRAM_LAYERS.Remove(adc);
                        }
                    }
                    foreach (var zone in differences.DeletedZones)
                    {
                        var adc = context.DIAGRAM_ZONES.FirstOrDefault(x => x.Assessment_Id == assessment_id && x.DrawIO_id == zone.Key);
                        if (adc != null)
                        {
                            context.DIAGRAM_ZONES.Remove(adc);
                        }
                    }
                    context.SaveChanges();
                    foreach(var layer in differences.AddedLayers)
                    {
                        var l = context.DIAGRAM_LAYERS.Where(x => x.DrawIO_id == layer.Key).FirstOrDefault();
                        if (l == null) {
                            context.DIAGRAM_LAYERS.Add(new DIAGRAM_LAYERS()
                             {
                                 Assessment_Id = assessment_id,
                                 DrawIO_id = layer.Key,
                                 Layer_Name = layer.Value.LayerName,
                                 Visible = layer.Value.Visible
                             });
                        }
                        else
                        {
                            l.Layer_Name = layer.Value.LayerName;
                            l.Visible = layer.Value.Visible;

                        }
                    }
                    foreach (var zone in differences.AddedZones)
                    {
                        var z = context.DIAGRAM_ZONES.Where(x => x.DrawIO_id == zone.Key).FirstOrDefault();
                        if (z == null)
                        {
                            context.DIAGRAM_ZONES.Add(new DIAGRAM_ZONES()
                            {
                                Assessment_Id = assessment_id,
                                DrawIO_id = zone.Key,
                                Zone_Name = zone.Value.ComponentName,
                                Universal_Sal_Level = zone.Value.SAL
                            });
                        }
                        else
                        {
                            z.Universal_Sal_Level = zone.Value.SAL;
                            z.Zone_Name = zone.Value.ComponentName;                            
                        }
                    }
                    context.SaveChanges();

                    Dictionary<string, int> zlookup = context.DIAGRAM_ZONES.Where(x=> x.Assessment_Id == assessment_id).ToList().ToDictionary(x => x.DrawIO_id, x => x.Zone_Id);
                    Dictionary<string, int> layerLookup = context.DIAGRAM_LAYERS.Where(x => x.Assessment_Id == assessment_id).ToList().ToDictionary(x => x.DrawIO_id, x => x.Layer_Id);


                    foreach (var newNode in differences.AddedNodes)
                    {
                        int zone_id, layer_id;
                        bool zIsNull, lIsNull = false;
                        zIsNull = !zlookup.TryGetValue(newNode.Value.Parent_id, out zone_id);
                        lIsNull = !layerLookup.TryGetValue(newNode.Value.Parent_id, out layer_id);

                        context.ASSESSMENT_DIAGRAM_COMPONENTS.Add(new ASSESSMENT_DIAGRAM_COMPONENTS()
                        {
                            Assessment_Id = assessment_id,
                            Component_Id = newNode.Key,
                            Diagram_Component_Type = newNode.Value.ComponentType,
                            DrawIO_id = newNode.Value.ID,
                            label = newNode.Value.ComponentName, 
                            Layer_Id = lIsNull? null: (int?) layer_id,
                            Zone_Id = zIsNull? null: (int?) zone_id
                        });
                    }
                    context.SaveChanges();

                    foreach(var node in newDiagram.getParentChanges())
                    {
                        //find the new parent zone or layer and set it
                        var n = context.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.DrawIO_id == node.ID).FirstOrDefault();
                        if (n != null)
                        {
                            //try zone first if it is zone then the component gets the zone's layer
                            //then try layer
                            //then assume we are broken
                            int parent_id; 
                            if(zlookup.TryGetValue(n.DrawIO_id,out parent_id))
                            {
                                n.Zone_Id = parent_id;
                                n.Layer_Id = context.DIAGRAM_ZONES.Where(x=> x.Zone_Id == parent_id).First().
                            }

                        }
                        
                    }

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
            IdentifyComponentLayerZoneChanges(newDiagram.NetworkComponents.Cast<NetworkNode>().ToList(), newDiagram.OldParentIds);
            IdentifyComponentLayerZoneChanges(newDiagram.Zones.Cast<NetworkNode>().ToList(), newDiagram.OldParentIds);
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

