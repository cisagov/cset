//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.analysis.helpers;
using CSETWebCore.Business.Diagram.Analysis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml;

namespace CSETWebCore.Business.BusinessManagers.Diagram.analysis
{

    /// <summary>
    /// this class is responsible for parsing the diagram xml
    /// and building the simplified network structure for the rules.
    /// </summary>
    public class SimplifiedNetwork
    {
        private Dictionary<String, NetworkComponent> nodes = new Dictionary<string, NetworkComponent>();
        private List<NetworkLink> Links = new List<NetworkLink>();
        private Dictionary<string, NetworkLayer> layers = new Dictionary<string, NetworkLayer>();
        //drawio id to zone lookup
        private Dictionary<string, NetworkZone> zones = new Dictionary<string, NetworkZone>();
        private Dictionary<string, int> imageToTypePath;
        private string defaultSal;
        private NetworkZone defaultZone;

        public Dictionary<String, NetworkComponent> Nodes
        {
            get
            {
                return nodes;
            }
            private set
            {
            }
        }

        public List<NetworkLink> Edges
        {
            get { return Links; }
        }




        public SimplifiedNetwork(Dictionary<string, int> imageToTypePath, string defaultSAL)
        {
            this.imageToTypePath = imageToTypePath;
            this.defaultSal = defaultSAL;
            this.defaultZone = new NetworkZone()
            {
                SAL = defaultSAL,
                ZoneType = "None"
            };
        }


        public void ExtractNetworkFromXml(XmlDocument xDoc)
        {
            //create a dictionary of connected graphs
            //go through the document creating each node and its connections
            //have a dictionary of nodes to see if we saw this node already
            //if so do not recreate it. 
            //if not create the node and it's connections
            //once the graph is built pick a node and start moving through them 
            //to extract minimal spanning tree(s)
            //then walk the tree to evaluate node rules

            //for the XmlNodeLists, use the '/object' ones for diagram-orig, and '/UserObject' for the WIP diagram
            XmlNodeList objectNodes = xDoc.SelectNodes("/mxGraphModel/root/object[not(@redDot)]");
            if (objectNodes.Count == 0)
            {
                objectNodes = xDoc.SelectNodes("/mxGraphModel/root/UserObject[not(@redDot)]");
            }

            XmlNodeList zoneNodes = xDoc.SelectNodes("//*[@zone=\"1\"]");

            XmlNodeList mxCellLinkObjects = xDoc.SelectNodes("/mxGraphModel/root/object[mxCell/@edge='1']");
            if (mxCellLinkObjects.Count == 0)
            {
                mxCellLinkObjects = xDoc.SelectNodes("/mxGraphModel/root/UserObject[mxCell/@edge='1']");
            }

            XmlNodeList mxCellLinks = xDoc.SelectNodes("//*[@edge=\"1\"]");

            XmlNodeList mxCellLayers = xDoc.SelectNodes("//*[@parent=\"0\" and @id]");
            foreach (XmlNode layer in mxCellLayers)
            {
                string id = layer.Attributes["id"].Value;
                layers.Add(id, new NetworkLayer()
                {
                    ID = id,
                    LayerName = layer.Attributes["value"] != null ? layer.Attributes["value"].Value : Constants.Constants.DEFAULT_LAYER_NAME,
                    Visible = layer.Attributes["visible"] != null ? (layer.Attributes["visible"].Value == "0" ? false : true) : true
                });
            }

            foreach (XmlNode node in zoneNodes)
            {
                //determine if it is an edge or a node
                //if it is an node look it up(should be new)
                //and create it
                //if it is an edge then we need to save it until all the nodes are created
                //once we have them all start connecting everything up. 

                //if it is a zone then just skip it
                if (((XmlElement)node).HasAttribute("zone"))
                {
                    string zone = node.Attributes["id"].Value;

                    zones.Add(zone, new NetworkZone()
                    {
                        ID = zone,
                        ZoneType = node.Attributes["ZoneType"].Value,
                        SAL = node.Attributes["SAL"].Value
                    });
                }
            }


            foreach (XmlNode node in objectNodes)
            {
                //determine if it is an edge or a node
                //if it is an node look it up(should be new)
                //and create it
                //if it is an edge then we need to save it until all the nodes are created
                //once we have them all start connecting everything up. 

                //if it is a zone then just skip it
                if (((XmlElement)node).HasAttribute("zone"))
                {
                    continue;
                }


                //do a little preprocessing to get the attribute values
                var styleString = node.FirstChild.Attributes["style"]?.Value ?? "";


                // if it is a group then skip it
                if (styleString.Split(';').Contains("group"))
                {
                    continue;
                }


                int nodeType = 0;

                string imgPath;
                if (DrawIOParsingHelps.DecodeQueryParameters(styleString.Replace("image;", "")).TryGetValue("image", out imgPath))
                {
                    if (!imageToTypePath.TryGetValue(imgPath.Replace("img/cset/", ""), out nodeType))
                    {

                    }
                }
                else
                {
                    //I think we can assume
                    nodeType = 49;// "MSC";
                }

                //get the parent value if it is in the layers dictionary then set the
                //visible value to the value of the parent
                //else set it to visible
                string layername = node.FirstChild.Attributes["parent"].Value;
                NetworkLayer layer;
                bool IsVisible = true;
                if (layers.TryGetValue(layername, out layer))
                {
                    if (!layer.Visible)
                    {
                        //if it is not visible skip it. 
                        continue;
                    }
                }

                //extract the geometry to a point on the component
                NetworkGeometry geometry = new NetworkGeometry(node.FirstChild.FirstChild);

                NetworkComponent dnode;
                string id = node.Attributes["id"].Value;
                if (nodes.TryGetValue(id, out dnode))
                {
                    //this should never happen we should never have a duplicate id
                }
                else
                {

                    dnode = new NetworkComponent()
                    {
                        ComponentGuid = ((XmlElement)node).HasAttribute("ComponentGuid") ? Guid.Parse(node.Attributes["ComponentGuid"].Value) : new Guid(),
                        ID = node.Attributes["id"].Value,
                        ComponentName = ((XmlElement)node).HasAttribute("label") ? node.Attributes["label"].Value : "",
                        Component_Symbol_Id = nodeType,
                        //ComponentType = nodeType,
                        IsVisible = IsVisible,
                        Parent_id = layername,
                        Geometry = geometry
                    };

                    NetworkZone myzone;
                    if (zones.TryGetValue(layername, out myzone))
                    {
                        dnode.Zone = myzone;
                    }
                    else
                    {
                        dnode.Zone = defaultZone;
                    }
                    nodes.Add(id, dnode);
                }
            }

            //the mxCellLinks list also has the objects
            //so we keep track of the child id's and 
            //if we see them again in the raw links
            //then just skip it.             
            foreach (XmlNode node in mxCellLinkObjects)
            {
                XmlElement xNode = (XmlElement)node;
                var link = new NetworkLink();
                foreach (XmlAttribute a in node.Attributes)
                {
                    link.SetValue(a.Name, a.Value);
                }
                Links.Add(link);
                var childnode = ((XmlElement)xNode.FirstChild);
                //find each node
                //add them to each other          
                if (childnode.HasAttribute("source") && childnode.HasAttribute("target"))
                {
                    NetworkComponent start = findNode(childnode.Attributes["source"].Value);
                    NetworkComponent target = findNode(childnode.Attributes["target"].Value);
                    //map any other attributes
                    link.SourceComponent = start;
                    link.TargetComponent = target;
                    start?.AddEdge(target, link);
                    target?.AddEdge(start, link);
                }
            }
            foreach (XmlNode node in mxCellLinks)
            {
                XmlElement xNode = (XmlElement)node;
                if (((XmlElement)xNode.ParentNode).Name == "object")
                {
                    continue;//skip it
                }
                //find each node
                //add them to each other          
                if (xNode.HasAttribute("source") && xNode.HasAttribute("target") && xNode.HasAttribute("id"))
                {
                    NetworkComponent start = findNode(node.Attributes["source"].Value);
                    NetworkComponent target = findNode(node.Attributes["target"].Value);
                    //map any other attributes
                    var link = new NetworkLink();
                    link.ID = xNode.Attributes["id"].Value;
                    link.SourceComponent = start;
                    link.TargetComponent = target;
                    Links.Add(link);
                    start?.AddEdge(target, link);
                    target?.AddEdge(start, link);
                }
            }
            this.nodes = PostProcessConnectors.RemoveConnectors(nodes);
        }

        private NetworkComponent findNode(string id)
        {
            NetworkComponent dnode;
            if (nodes.TryGetValue(id, out dnode))
            {
                return dnode;
            }
            else
            {
                return null;
            }
        }
    }
}
