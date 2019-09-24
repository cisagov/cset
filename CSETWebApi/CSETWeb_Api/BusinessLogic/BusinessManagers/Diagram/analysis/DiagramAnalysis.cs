//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.Linq;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.Analysis;
using DataLayerCore.Model;
using Newtonsoft.Json;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    public enum LinkSecurityEnum
    {
        Trusted, Untrusted
    }

    public class DiagramAnalysis
    {
        private Dictionary<String, NetworkComponent> nodes = new Dictionary<string, NetworkComponent>();
        private List<NetworkLink> Links = new List<NetworkLink>();
        private Dictionary<Guid, DiagramAnalysisLineMessage> dictionaryLineMessages = new Dictionary<Guid, DiagramAnalysisLineMessage>();
        private Dictionary<Guid, DiagramAnalysisNodeMessage> dictionaryNodeMessages = new Dictionary<Guid, DiagramAnalysisNodeMessage>();

        private List<NetworkAnalysisNode> ListAnalysisNodes = new List<NetworkAnalysisNode>();
        private List<INetworkAnalysisMessage> ListAnalysisMessages = new List<INetworkAnalysisMessage>();
        
        private CSET_Context db;
        private Dictionary<string, string> imageToTypePath = new Dictionary<string, string>();
        private Dictionary<string, NetworkLayer> layers = new Dictionary<string, NetworkLayer>();

        //drawio id to zone lookup
        private Dictionary<string, NetworkZone> zones = new Dictionary<string, NetworkZone>();

        private int nextMessage = 1;

        public XmlDocument NetworkWarningsXml { get; private set; }
        public List<IDiagramAnalysisNodeMessage> NetworkWarnings { get; private set; }

        public DiagramAnalysis(CSET_Context db)
        {
            this.db = db;
            imageToTypePath = db.COMPONENT_SYMBOLS.ToDictionary(x => x.File_Name, x => x.Diagram_Type_Xml);
            NetworkWarnings = new List<IDiagramAnalysisNodeMessage>();
        }

        public void PerformAnalysis(XmlDocument xDoc)
        {
            //create a dictionary of connected graphs
            //go through the document creating each node and its connections
            //have a dictionary of nodes to see if we saw this node already
            //if so do not recreate it. 
            //if not create the node and it's connections
            //once the graph is built pick a node and start moving through them 
            //to extract minimal spanning tree(s)
            //then walk the tree to evaluate node rules




            XmlNodeList objectNodes = xDoc.SelectNodes("/mxGraphModel/root/object[not(@redDot)]");
            XmlNodeList zoneNodes = xDoc.SelectNodes("//*[@zone=\"1\"]");
            XmlNodeList mxCellLinks = xDoc.SelectNodes("//*[@edge=\"1\"]");
            XmlNodeList mxCellLayers = xDoc.SelectNodes("//*[@parent=\"0\" and @id]");
            foreach (XmlNode layer in mxCellLayers)
            {
                string id = layer.Attributes["id"].Value;
                layers.Add(id, new NetworkLayer()
                {
                    ID = id,
                    LayerName = layer.Attributes["value"] != null ? layer.Attributes["value"].Value : "Main Layer",
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
                        ZoneType = node.Attributes["zoneType"].Value,
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
                var styleString = node.FirstChild.Attributes["style"].Value;


                // if it is a group then skip it
                if (styleString.Split(';').Contains("group"))
                {
                    continue;
                }


                string nodeType = null;

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
                    nodeType = "MSC";
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
                        ComponentType = nodeType,
                        IsVisible = IsVisible,
                        Geometry = geometry
                    };
                    NetworkZone myzone;
                    if (zones.TryGetValue(layername, out myzone))
                    {
                        dnode.Zone = myzone;
                    }
                    nodes.Add(id, dnode);
                }
            }

            foreach (XmlNode node in mxCellLinks)
            {
                XmlElement xNode = (XmlElement)node;
                //find each node
                //add them to each other          
                if (xNode.HasAttribute("source") && xNode.HasAttribute("target"))
                {
                    NetworkComponent start = findNode(node.Attributes["source"].Value);
                    NetworkComponent target = findNode(node.Attributes["target"].Value);
                    Links.Add(new NetworkLink()
                    {

                    });
                    start?.AddEdge(target);
                    target?.AddEdge(start);
                }
                else
                {

                }

            }
            AnalyzeNetwork();

            //set both the xml and the json
            this.NetworkWarningsXml = ProcessNetworkMessages();
            if (xDoc.DocumentElement != null && this.NetworkWarningsXml.DocumentElement != null)
            {
                XmlNode root = xDoc.DocumentElement.FirstChild;
                XmlNode r = xDoc.ImportNode(this.NetworkWarningsXml.DocumentElement, true);
                root.AppendChild(r);
            }
        }





        /// <summary>
        /// Go through the messages and create the red dot 
        /// cells for the diagram.
        /// </summary>
        /// <returns>
        /// returns an xmldocument that can be converted to json to return to client
        /// or directly added to a diagram on import or other api side diagram manipulations
        /// </returns>
        private XmlDocument ProcessNetworkMessages()
        {
            //generate the string
            //convert it to an xmlnode
            //add the node to the document 
            //save to database
            //force reload
            XmlDocument start = new XmlDocument();
            this.NetworkWarnings.Clear();
            foreach (var message in dictionaryNodeMessages.Values)
            {
                this.NetworkWarnings.Add((IDiagramAnalysisNodeMessage)message);
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(message.XmlValue);
                if (start.DocumentElement == null)
                {
                    start = doc;
                }
                else
                {
                    XmlNode newNode = doc.DocumentElement;
                    XmlNode root = start.DocumentElement;
                    XmlNode r = start.ImportNode(newNode, true);
                    root.AppendChild(r);
                }
            }
            return start;
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

        public void AnalyzeNetwork()
        {
            checkRule1();
        }

        /*
         * look at every edge are the enpoints in different zones. 
         * if so then we need to consider those edges. 
         * do a breadth first search if we find an object that is not a firewall 
         */




        //private void SetNodeMessage(NetworkNode component, string text)
        //{
        //    DiagramAnalysisNodeMessage messageNode;
        //    if (dictionaryNodeMessages.ContainsKey(component.ComponentGuid))
        //    {
        //        messageNode = dictionaryNodeMessages[component.ComponentGuid];
        //    }
        //    else
        //    {
        //        messageNode = new DiagramAnalysisNodeMessage()
        //        {
        //            Component = component
        //        };
        //        dictionaryNodeMessages.Add(component.ComponentGuid, messageNode);
        //    }
        //    messageNode.AddMessage(text);
        //}

        private void RunAnalysis()
        {

            List<INetworkAnalysisMessage> listMessages = new List<INetworkAnalysisMessage>();
            dictionaryLineMessages.Clear();
            dictionaryNodeMessages.Clear();

            HashSet<Guid> checkedLines = new HashSet<Guid>();

            //walk the tree at each node do some analysis. 



            //foreach (NetworkLink link in Links)
            //{
            //    if (link.IsVisible)
            //    {
            //        NetworkNode headComponent = link.TargetComponent;
            //        NetworkNode tailComponent = link.SourceComponent;
            //        if (headComponent == null || tailComponent == null)
            //            continue;

            //        CheckRule12(link, headComponent, tailComponent);
            //        CheckRule6(checkedLines, link, headComponent, tailComponent);
            //    }
            //}

            //foreach (NetworkNode component in nodes.Values)
            //{
            //    if (component.IsVisible)
            //    {
            //        CheckRule5(component);
            //        CheckRule34(component);
            //        CheckRule7(component);
            //    }
            //}

            //int messageIdentifier = 1;
            //if (dictionaryNodeMessages.Count > 0)
            //{
            //    int i = 0;
            //    i++;
            //}
            //foreach (DiagramAnalysisNodeMessage message in dictionaryNodeMessages.Values)
            //{

            //    NetworkAnalysisMessage messageAnalysis = new NetworkAnalysisMessage() { MessageIdentifier = messageIdentifier, Message = message.GetMessage() };
            //    listMessages.Add(messageAnalysis);
            //    CreateNodeMsgAnalysisNode(message, messageAnalysis);
            //    messageIdentifier++;

            //}

            ////Set messages
            //foreach (DiagramAnalysisLineMessage message in dictionaryLineMessages.Values)
            //{
            //    NetworkAnalysisMessage messageAnalysis = new NetworkAnalysisMessage() { MessageIdentifier = messageIdentifier, Message = message.GetMessage() };
            //    listMessages.Add(messageAnalysis);
            //    CreateLineMsgAnalysisNode(message, messageAnalysis);
            //    messageIdentifier++;
            //}

            //ListAnalysisMessages.AddRange(listMessages);
        }

  




        ///// <summary>
        ///// Many of the rules have to do with crossing an enclave boundary
        ///// (this also includes
        ///// </summary>
        ///// <returns></returns>
        //private List<NetworkLink> findAllCrossingEdges()
        //{

        //}




        //private List<EdgeNodeInfo> CheckFirewallUni(NetworkLink link, NetworkNode component, HashSet<Guid> SetVisted = null)
        //{
        //    SetVisted = SetVisted ?? new HashSet<Guid>();
        //    SetVisted.Add(component.ID);
        //    List<EdgeNodeInfo> listInfo = new List<EdgeNodeInfo>();

        //    if (component.IsFirewall || component.IsUnidirectional)
        //    {
        //        return listInfo;
        //    }
        //    else if (!component.IsLinkConnector && !component.IsSerialRadio && !component.IsSerialSwitch && !component.IsLinkEncryption)
        //    {
        //        listInfo.Add(new EdgeNodeInfo() { Link = link, EndComponent = component });
        //        return listInfo;
        //    }
        //    else
        //    {
        //        CheckFirewallUniRecursive(ref listInfo, SetVisted, component);
        //        return listInfo;
        //    }


        //}

        //private void CheckFirewallUniRecursive(ref List<EdgeNodeInfo> listNode, HashSet<Guid> visitedNodes, NetworkNode component)
        //{
        //    foreach (NetworkLink edge in component.GetConnectors())
        //    {
        //        NetworkNode otherComponent = GetOtherComponent(edge, component);
        //        if (otherComponent == null)
        //            continue;
        //        //Debug.WriteLine("Node:" + otherComponent.Node.ID.ToString() + " " + otherComponent.Node.Label + " Type: " + otherComponent.Data.NodeType);

        //        if (CheckAddVisited(visitedNodes, otherComponent))
        //            continue;
        //        //Debug.WriteLine("Visited:");
        //        //visitedNodes.ToList().ForEach(x => Debug.WriteLine(x.ToString()));

        //        if (otherComponent.IsLinkConnector || otherComponent.IsSerialRadio || otherComponent.IsSerialSwitch || otherComponent.IsLinkEncryption)
        //        {
        //            CheckFirewallUniRecursive(ref listNode, visitedNodes, otherComponent);
        //        }
        //        else
        //        {
        //            if (otherComponent.IsFirewall)
        //            {
        //                continue;
        //            }
        //            else if (otherComponent.IsIDSOrIPS)
        //            {
        //                continue;
        //            }
        //            else if (otherComponent.IsUnidirectional)
        //                continue;
        //            else
        //            {
        //                listNode.Add(new EdgeNodeInfo { Link = edge, EndComponent = otherComponent });
        //            }
        //        }
        //    }
        //}

        



        //private void AddMessage(NetworkLink link, String text)
        //{
        //    //Don't add analysis message to diagram if either source or target is null or the are not visible.
        //    if (link.Source == null || link.Target == null)
        //        return;
        //    else
        //    {
        //        NetworkNode componentSource = link.Source as NetworkNode;
        //        if (componentSource != null)
        //        {
        //            if (componentSource.IsVisible == false)
        //                return;
        //        }

        //        NetworkNode componentTarget = link.Target as NetworkNode;
        //        if (componentTarget != null)
        //        {
        //            if (componentTarget.IsVisible == false)
        //                return;
        //        }

        //    }
        //    DiagramAnalysisLineMessage messageLine;
        //    if (dictionaryLineMessages.ContainsKey(link.ID))
        //    {
        //        messageLine = dictionaryLineMessages[link.ID];
        //    }
        //    else
        //    {
        //        messageLine = new DiagramAnalysisLineMessage(link);
        //        dictionaryLineMessages.Add(link.ID, messageLine);
        //    }
        //    messageLine.AddMessage(text);
        //}

        //private List<EdgeNodeInfo> GetNodeEdges(NetworkNode component, HashSet<String> typeNodes, HashSet<Guid> SetVisted = null)
        //{
        //    SetVisted = SetVisted ?? new HashSet<Guid>();
        //    SetVisted.Add(component.ID);
        //    List<EdgeNodeInfo> listInfo = new List<EdgeNodeInfo>();
        //    GetNodeInfoRecursive(ref listInfo, typeNodes, SetVisted, component);
        //    return listInfo;
        //}

        //private void GetNodeInfoRecursive(ref List<EdgeNodeInfo> listNode, HashSet<String> typeNodes, HashSet<Guid> visitedNodes, NetworkNode component)
        //{
        //    IEnumerable<NetworkLink> edges = component.GetConnectors();
        //    foreach (NetworkLink edge in edges)
        //    {
        //        NetworkNode otherComponent = GetOtherComponent(edge, component);
        //        if (otherComponent == null)
        //            continue;
        //        //Debug.WriteLine("Node:" + otherComponent.Node.ID.ToString() + " "  + otherComponent.Node.Label + " Type: " + otherComponent.Data.NodeType);
        //        if (CheckAddVisited(visitedNodes, otherComponent))
        //            continue;
        //        //Debug.WriteLine("Visited:");
        //        // visitedNodes.ToList().ForEach(x => Debug.WriteLine(x.ToString() + "\n"));

        //        if (otherComponent.IsLinkConnector)
        //        {
        //            GetNodeInfoRecursive(ref listNode, typeNodes, visitedNodes, otherComponent);
        //        }
        //        else
        //        {
        //            if (otherComponent.IsNotComponentTypes(typeNodes))
        //            {
        //                listNode.Add(new EdgeNodeInfo { Link = edge, EndComponent = otherComponent });
        //            }
        //        }
        //    }
        //}

        //private bool CheckAddVisited(HashSet<Guid> visitedNodes, NetworkNode otherComponent)
        //{

        //    if (visitedNodes.Contains(otherComponent.ID))
        //        return true;
        //    else
        //    {
        //        visitedNodes.Add(otherComponent.ID);
        //        return false;
        //    }
        //}

        //private NetworkNode GetOtherComponent(NetworkLink link, NetworkNode component)
        //{
        //    NetworkNode sourceComponent = link.SourceComponent;
        //    NetworkNode targetComponent = link.TargetComponent;
        //    if (sourceComponent != null)
        //    {
        //        if (sourceComponent.ID == component.ID)
        //        {
        //            return targetComponent;
        //        }
        //        else
        //        {
        //            return sourceComponent;
        //        }
        //    }
        //    else if (targetComponent != null)
        //    {
        //        if (targetComponent.ID == component.ID)
        //        {
        //            return sourceComponent;
        //        }
        //        else
        //        {
        //            return targetComponent;
        //        }
        //    }
        //    else
        //    {
        //        return null;
        //    }

        //}


        //private void CreateNodeMsgAnalysisNode(DiagramAnalysisNodeMessage message, NetworkAnalysisMessage messageAnalysis)
        //{
        //    double x = 0;
        //    double y = 0;
        //    if (message.Component is MultiServiceComponent)
        //    {
        //        x = message.Component.CSETPosition.X + message.Component.Width / 2.0 - 15;
        //        y = message.Component.CSETPosition.Y - 35;
        //    }
        //    else
        //    {
        //        x = message.Component.CSETPosition.X + message.Component.Width / 2.0;
        //        y = message.Component.CSETPosition.Y - message.Component.Height / 2.0;
        //    }
        //    CreateAnalyisNode(message.Component.Layer, new Point(x, y), messageAnalysis);
        //}


        ///// <summary>
        ///// Put the message at the mid point between the to end nodes
        ///// </summary>
        ///// <param name="label"></param>
        ///// <param name="text"></param>
        ///// <param name="connector"></param>
        //private void CreateLineMsgAnalysisNode(DiagramAnalysisLineMessage message, NetworkAnalysisMessage messageAnalysis)
        //{
        //    try
        //    {
        //        NetworkLink connector = message.Connector;
        //        if (connector.IsVisible)
        //        {
        //            if (connector.TargetComponent != null & connector.SourceComponent != null)
        //            {
        //                double xHead = connector.StartPoint.X;
        //                double yHead = connector.StartPoint.Y;
        //                double xTail = connector.EndPoint.X;
        //                double yTail = connector.EndPoint.Y;
        //                double xMid = (xHead + xTail) / 2.0;
        //                double yMid = (yHead + yTail) / 2.0;
        //                CreateAnalyisNode(connector.Layer, new Point(xMid, yMid), messageAnalysis);
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        CSET_Main.Common.CSETLogger.Fatal("An exception occurred in putting a node on the diagram. Exception: " + ex);
        //    }
        //}

        //private void CreateAnalyisNode(DiagramLayer layer, Point position, NetworkAnalysisMessage message)
        //{
        //    NetworkAnalysisNode node = new NetworkAnalysisNode();
        //    node.Content = message.MessageIdentifier.ToString();
        //    node.NetworkText = message.Message;
        //    node.Position = position;

        //    ListAnalysisNodes.Add(node);
        //    NetworkContainer.AddNode(node);
        //    layer.AddAnalyzeNodes(node);
        //}

        //public void SetDisableAnalysis()
        //{
        //    DisableAnalysis = true;
        //}

        //public void EnableAnalysisAndRun()
        //{
        //    DisableAnalysis = false;
        //    AnalyzeNetwork();
        //}

        //public void EnableAnalysis()
        //{
        //    DisableAnalysis = false;
        //}

        /// <summary>
        ///TODO MOVE TO public utility class
        /// </summary>
        /// <param name="uri"></param>
        /// <returns></returns>

    }
}