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
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    public enum LinkSecurityEnum
    {
        Trusted, Untrusted
    }

    public class DiagramAnalysis
    {
        private Dictionary<String, NetworkNode> nodes = new Dictionary<string, NetworkNode>();
        private List<NetworkLink> Links = new List<NetworkLink>();
        private Dictionary<Guid, DiagramAnalysisLineMessage> dictionaryLineMessages = new Dictionary<Guid, DiagramAnalysisLineMessage>();
        private Dictionary<Guid, DiagramAnalysisNodeMessage> dictionaryNodeMessages = new Dictionary<Guid, DiagramAnalysisNodeMessage>();

        private List<NetworkAnalysisNode> ListAnalysisNodes = new List<NetworkAnalysisNode>();
        private List<INetworkAnalysisMessage> ListAnalysisMessages = new List<INetworkAnalysisMessage>();
        private String rule1 = "The network path identified by the components, {0} and {1}, appears to connect network segments whose components reside in different zones.  A firewall to filter the traffic on this path is recommended to protect the components in one zone from a compromised component in the other zone.";
        private CSET_Context db;
        private Dictionary<string, string> imageToTypePath = new Dictionary<string, string>();
        private Dictionary<string, NetworkLayer> layers = new Dictionary<string, NetworkLayer>();
        private int nextMessage = 1; 


        public DiagramAnalysis(CSET_Context db)
        {
            this.db = db;
            imageToTypePath = db.COMPONENT_SYMBOLS.ToDictionary(x => x.File_Name, x => x.Diagram_Type_Xml);
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


            
            
            XmlNodeList objectNodes = xDoc.SelectNodes("/mxGraphModel/root/object");
            XmlNodeList mxCellLinks = xDoc.SelectNodes("//*[@edge=\"1\"]");
            XmlNodeList mxCellLayers = xDoc.SelectNodes("//*[@parent=\"0\"]");
            foreach(XmlNode layer in mxCellLayers)
            {
                string id = layer.Attributes["id"].Value;
                layers.Add(id, new NetworkLayer()
                {
                    ID = id,
                    LayerName = layer.Attributes["value"] != null ? layer.Attributes["value"].Value : "Background",
                    Visible = layer.Attributes["visible"] != null ? (layer.Attributes["visible"].Value == "0" ? false : true) : true
                });
            }


            foreach (XmlNode node in objectNodes)
            {
                //determine if it is an edge or a node
                //if it is an node look it up(should be new)
                //and create it
                //if it is an edge then we need to save it until all the nodes are created
                //once we have them all start connecting everything up. 

                //do a little preprocessing to get the attribute values
                var styleString = node.FirstChild.Attributes["style"].Value;
                string nodeType = null;
                string imgPath = DecodeQueryParameters(styleString.Replace("image;",""))["image"];
                if (!imageToTypePath.TryGetValue(imgPath.Replace("img/cset/",""), out nodeType))
                {
                    //TODO Add some error handling if we can't find the node type.
                }
                //get the parent value if it is in the layers dictionary then set the
                //visible value to the value of the parent
                //else set it to visible
                string layername = node.FirstChild.Attributes["parent"].Value;
                NetworkLayer layer;
                bool IsVisible = true;
                if(layers.TryGetValue(layername,out layer))
                {
                    if (!layer.Visible)
                    {
                        //if it is not visible skip it. 
                        continue;
                    }
                }

                //extract the geometry to a point on the component
                NetworkGeometry geometry = new NetworkGeometry(node.FirstChild.FirstChild);

                NetworkNode dnode; 
                string id = node.Attributes["id"].Value;
                if (nodes.TryGetValue(id,out dnode))
                {

                }
                else
                {
                    dnode = new NetworkNode()
                    {
                        ComponentGuid = Guid.Parse(node.Attributes["ComponentGuid"].Value),
                        ID = node.Attributes["id"].Value,
                        ComponentName = node.Attributes["label"].Value,
                        ComponentType = nodeType,
                        IsVisible = IsVisible,
                        Geometry = geometry
                    };
                    nodes.Add(id, dnode);
                }
            }

            foreach (XmlNode node in mxCellLinks)
            {   
                //find each node
                //add them to each other             
                NetworkNode start = findNode(node.Attributes["source"].Value);
                NetworkNode target  = findNode(node.Attributes["target"].Value);                
                Links.Add(new NetworkLink()
                {
                    
                });
                start.AddEdge(target);
                target.AddEdge(start);
                
            }
            AnalyzeNetwork();
            ProcessNetworkMessages(xDoc);
        }

        /// <summary>
        /// Go through the messages and add the red dot 
        /// to the diagram.
        /// </summary>
        private void ProcessNetworkMessages(XmlDocument xDoc)
        {
            //generate the string
            //convert it to an xmlnode
            //add the node to the document 
            //save to database
            //force reload

            foreach(var message in dictionaryNodeMessages.Values)
            {
                string warning = "  <mxCell id=\"{0}\" value=\"1\" style=\"ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#FF0000;fontColor=#FFFFFF;fontSize=13;\" vertex=\"1\" parent=\"{2}\">" +
                            "      <mxGeometry x=\"{3}\" y=\"{4}\" width=\"20\" height=\"20\" as=\"geometry\"/>" +
                            "    </mxCell>";
                //0 id  //1 Message Number //2 layer //3 x //4 y

                string xmlContent = String.Format(warning, Guid.NewGuid().ToString(), message.Number, message.Component.LayerId, message.Component.Geometry.point.X, message.Component.Geometry.point.Y);
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(xmlContent);
                XmlNode newNode = doc.DocumentElement;
                XmlNode root =  xDoc.DocumentElement.FirstChild;
                root.AppendChild(newNode);
                Trace.Write(xDoc.ToString());
            }
        }

        private NetworkNode findNode(string id)
        {
            NetworkNode dnode;
            if (nodes.TryGetValue(id, out dnode))
            {
                return dnode;
            }
            else
            {
                throw new NodeNotFound();
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
        
          

        private void checkRule1()
        {
            //get the list of vendors, partners, or web
            //if the vendor, partner, or web is connected to anything other than a firewall
            //add a message and let the user know.
            List<string> suspects = new List<string>();
            suspects.Add("Web");
            suspects.Add("Vendor");
            suspects.Add("Partner");
            var suspectslist = nodes.Values.Where(x => suspects.Contains(x.ComponentType));
            foreach (var node in suspectslist)
            {
                foreach (var child in node.Connections)
                {
                    if (child.ComponentType != "Firewall")
                    {
                        //flag node and put up the message
                        //if the message is already there over write with the latest edition
                        DiagramAnalysisNodeMessage msg;
                        if (dictionaryNodeMessages.TryGetValue(node.ComponentGuid, out msg)){
                            String text = String.Format(rule1, node.ComponentName);
                            msg.SetMessages.Add(text);
                        }
                        else
                        {
                            dictionaryNodeMessages.Add(node.ComponentGuid, new DiagramAnalysisNodeMessage()
                            {
                                Component = node,
                                SetMessages = new HashSet<string>(),
                                Number = nextMessage++
                            });
                        }
                    }
                }
            }
        }

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

        //private String rule7 = "Data flow between two distinct SAL zones via a unidirectional {0} must only flow from a higher SAL to a lower SAL." +
        //    " Example Control or SCADA network SAL High to Corporate Network SAL Low, but not SAL Low to SAL High.";


        /// <summary>
        /// rewriting the rules to make more sense  NOTE the data flows in the direction of the arrow
        /// so for this one we need to determine orientation of the device
        /// we want to recurse up into the network from the connections and 
        /// see if we can find some control system devices if we can 
        /// then data should only flow out of the control system side of the data diode
        /// if we find control systems components on both sides we should warn and have the user resolve it. 
        /// maybe we should popup a dialog to determine how to analyse the network
        /// 
        /// ie if this is classified then data should flow in 
        /// if this is control systems network 
        /// </summary>
        /// <param name="component"></param>
        private void CheckRule7(NetworkNode component)
        {
            //if (component.IsUnidirectional)
            //{
            //    SAL_LEVELS leftPosition = null;
            //    SAL_LEVELS rightPosition = null;
                
            //    foreach (NetworkLink link in connectors)
            //    {
            //        if (link.SourceComponent == null || link.TargetComponent == null)
            //            continue;

            //        NetworkNode otherComponent = GetOtherComponent(link, component);
            //        if (otherComponent == null)
            //            continue;

            //        String connectionPostion;

            //        if (link.TargetComponent.ID == component.ID)
            //        {
            //            connectionPostion = link.GetTargetConnectionPort();
            //        }
            //        else
            //        {
            //            connectionPostion = link.GetSourceConnectionPort();
            //        }
            //        if (connectionPostion == Constants.LEFT_UNI_CONNECTOR)
            //        {
            //            leftPosition = otherComponent.SAL;
            //        }
            //        else if (connectionPostion == Constants.RIGHT_UNI_CONNECTOR)
            //        {
            //            rightPosition = otherComponent.SAL;
            //        }
            //    }

            //    if (leftPosition != null && rightPosition != null)
            //    {
            //        bool isHighToLow;
            //        if (component.IsReverse)
            //            isHighToLow = rightPosition.Sal_Level_Order > leftPosition.Sal_Level_Order;
            //        else
            //            isHighToLow = rightPosition.Sal_Level_Order < leftPosition.Sal_Level_Order;

            //        String componentName = "unnamed";
            //        if (!String.IsNullOrWhiteSpace(component.TextNodeLabel))
            //        {
            //            componentName = component.TextNodeLabel;
            //        }

            //        if (!isHighToLow)
            //        {
            //            String text = String.Format(rule7, componentName);
            //            SetNodeMessage(component, text);
            //        }
            //    }
            //}
        }


        //private String rule3 = "The separate subnets handled by the VLAN component, {0}, carry traffic of different SALs.  The incorrect configuration of the component, or the possible compromise of the component, allow the critical traffic to be visible on the less protected network segment.";
        //private String rule4 = "The component, {0}, has multiple interfaces where the subnets of those interfaces carry traffic of different SALs.  If the component is compromised, the critical traffic could be visible from the less protected network.";


        ///// <summary>
        ///// rewrite rules  
        ///// 
        ///// </summary>
        ///// <param name="component"></param>
        //private void CheckRule34(NetworkNode component)
        //{
        //    if ((component.Subnets.Count) > 1)
        //    {
        //        List<EdgeNodeInfo> list = GetNodeEdges(component, new HashSet<string>() { Constants.FIREWALL_TYPE, Constants.UNIDIRECTIONAL_TYPE });
        //        int countSALs = list.Select(x => x.EndComponent.SAL.Selected_Sal_Level).Distinct().Count();
        //        if (countSALs > 2)
        //        {
        //            if (component.IsVLAN)
        //            {
        //                String componentName = "unnamed";
        //                if (!String.IsNullOrWhiteSpace(component.TextNodeLabel))
        //                {
        //                    componentName = component.TextNodeLabel;
        //                }

        //                String text = String.Format(rule3, componentName);
        //                SetNodeMessage(component, text);
        //            }
        //            else
        //            {
        //                String componentName = "unnamed";
        //                if (!String.IsNullOrWhiteSpace(component.TextNodeLabel))
        //                {
        //                    componentName = component.TextNodeLabel;
        //                }

        //                String text = String.Format(rule4, componentName);
        //                SetNodeMessage(component, text);
        //            }
        //        }
        //    }
        //}

        ///// <summary>
        ///// Many of the rules have to do with crossing an enclave boundary
        ///// (this also includes
        ///// </summary>
        ///// <returns></returns>
        //private List<NetworkLink> findAllCrossingEdges()
        //{

        //}


        //private void CheckRule12(NetworkLink link, NetworkNode headComponent, NetworkNode tailComponent)
        //{
        //    if (!headComponent.IsInSameZone(tailComponent))
        //    {
        //        //Debug.WriteLine("HeadComponent: " + headComponent.Node.ID + " " + headComponent.Node.Label);
        //        //Debug.WriteLine("tailComponent: " + tailComponent.Node.ID + " " + tailComponent.Node.Label);

        //        //Get All components that are not firewalls or unidirectional devices not connectors on head side of edge
        //        List<EdgeNodeInfo> listHead = CheckFirewallUni(link, headComponent, new HashSet<Guid>() { tailComponent.ID });

        //        //Get All that are not firewalls or unidirectional devices components that are not connectors on tail side of edge
        //        List<EdgeNodeInfo> listTail = CheckFirewallUni(link, tailComponent, new HashSet<Guid>() { headComponent.ID });

        //        //If one of these lists is empty then has sufficient filter because it means all the nodes on one
        //        //side have a firewall
        //        bool isFilterTrafficHead = listHead.Count == 0;
        //        bool isFilterTrafficTail = listTail.Count == 0;

        //        if (isFilterTrafficTail || isFilterTrafficHead)
        //            return;
        //        else
        //        {
        //            foreach (EdgeNodeInfo info in listHead)
        //            {
        //                if (info.EndComponent.IsPartnerVendorOrWeb)
        //                {
        //                    return;
        //                }
        //            }
        //            foreach (EdgeNodeInfo info in listTail)
        //            {
        //                if (info.EndComponent.IsPartnerVendorOrWeb)
        //                {
        //                    return;
        //                }
        //            }

        //            String headName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(headComponent.TextNodeLabel))
        //            {
        //                headName = headComponent.TextNodeLabel;
        //            }

        //            String tailName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(tailComponent.TextNodeLabel))
        //            {
        //                tailName = tailComponent.TextNodeLabel;
        //            }

        //            String text = String.Format(rule1, headName, tailName);
        //            AddMessage(link, text);
        //        }
        //    }

        //    if (headComponent.IsFirewall)
        //    {
        //        CheckRule2(headComponent);
        //    }

        //    if (tailComponent.IsFirewall)
        //    {
        //        CheckRule2(tailComponent);
        //    }
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

        //private String rule2 = "The subnet, {0}, should have an IDS (Intrusion Detection System) or IPS (Intrusion Prevention System) inline to confirm that the configuration of firewall, {1}, is correct and that malware has not been able to penetrate past the firewall.";

        ///// <summary>
        ///// Check Firewall for IPS and IDS past the firewall
        ///// </summary>
        ///// <param name="multiServiceComponent"></param>
        ///// <param name="visitedNodes"></param>
        //private void CheckRule2(NetworkNode firewall)
        //{
        //    if (firewall.IsIDSOrIPS) // This code is here because component can be a multiple service component that is IDS and IPS
        //    {
        //        return;
        //    }

        //    List<EdgeNodeInfo> list = GetNodeEdges(firewall, new HashSet<string>());
        //    foreach (EdgeNodeInfo info in list)
        //    {
        //        if (info.EndComponent.IsInSameZone(firewall))
        //        {
        //            if (info.EndComponent.IsIDSOrIPS)
        //            {
        //                return;
        //            }
        //        }
        //    }
        //    string subnet = "";

        //    HashSet<String> subnets = firewall.Subnets;
        //    if (subnets.Count > 0)
        //        subnet = subnets.ToList<String>()[0];
        //    else
        //        subnet = "unnamed";

        //    String componentName = "unnamed";
        //    if (!String.IsNullOrWhiteSpace(firewall.TextNodeLabel))
        //    {
        //        componentName = firewall.TextNodeLabel;
        //    }

        //    String text = String.Format(rule2, subnet, componentName);
        //    SetNodeMessage(firewall, text);
        //}

        //private String rule5 = "The path identified by the components, {0} and {1}, appears to connect on one side to an external network.  A firewall to filter the traffic to and from the external network is recommended to protect the facility's network.  Note that a 'Web' component, 'Vendor' component, or 'Partner' component are all assumed to interface with an external network.  In addition, a modem with a single connection is assumed to allow a connection from outside the facility's network.";

        //private void CheckRule5(NetworkNode component)
        //{
        //    if (component.IsPartnerVendorOrWeb)//Is it Firewall,Vendor,Partner
        //    {
        //        HashSet<Guid> VisitedNodes = new HashSet<Guid>();
        //        VisitedNodes.Add(component.ID);
        //        List<EdgeNodeInfo> list = GetNodeEdges(component, new HashSet<String>() { Constants.FIREWALL_TYPE });
        //        foreach (EdgeNodeInfo info in list)
        //        {
        //            String componentName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(component.TextNodeLabel))
        //            {
        //                componentName = component.TextNodeLabel;
        //            }

        //            String endComponentName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(info.EndComponent.TextNodeLabel))
        //            {
        //                endComponentName = info.EndComponent.TextNodeLabel;
        //            }

        //            String text = String.Format(rule5, componentName, endComponentName);
        //            AddMessage(info.Link, text);
        //        }
        //    }
        //}


        //private String rule6 = "The path between the components, {0} and {1}, is untrusted.  Because malicious traffic may be introduced onto the link, a firewall to filter the traffic on both sides of untrusted link is recommended.";


        //private void CheckRule6(HashSet<Guid> checkedLines, NetworkLink link, NetworkNode headComponent, NetworkNode tailComponent)
        //{
        //    if (link.Security == LinkSecurityEnum.Untrusted)
        //    {
        //        if (headComponent.IsFirewall || tailComponent.IsFirewall)
        //        {
        //            //If there is firewall don't show message
        //        }
        //        else
        //        {
        //            String headName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(headComponent.TextNodeLabel))
        //            {
        //                headName = headComponent.TextNodeLabel;
        //            }

        //            String tailName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(tailComponent.TextNodeLabel))
        //            {
        //                tailName = tailComponent.TextNodeLabel;
        //            }

        //            String text = String.Format(rule6, headName, tailName);
        //            AddMessage(link, text);
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
        public static Dictionary<string, string> DecodeQueryParameters(string uri)
        {
            if (uri == null)
                throw new ArgumentNullException("uri");

            if (uri.Length == 0)
                return new Dictionary<string, string>();

            return uri.TrimStart('?')
                            .Split(new[] { '&', ';' }, StringSplitOptions.RemoveEmptyEntries)
                            .Select(parameter => parameter.Split(new[] { '=' }, StringSplitOptions.RemoveEmptyEntries))
                            .GroupBy(parts => parts[0],
                                     parts => parts.Length > 2 ? string.Join("=", parts, 1, parts.Length - 1) : (parts.Length > 1 ? parts[1] : ""))
                            .ToDictionary(grouping => grouping.Key,
                                          grouping => string.Join(",", grouping));
        }
    }
}