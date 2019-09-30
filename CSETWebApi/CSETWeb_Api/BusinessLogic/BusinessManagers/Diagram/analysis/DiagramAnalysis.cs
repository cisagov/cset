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
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules;
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
        private CSET_Context db;
        private int assessment_id;
        private Dictionary<string, string> imageToTypePath;

        public XmlDocument NetworkWarningsXml { get; private set; }
        public List<IDiagramAnalysisNodeMessage> NetworkWarnings { get; private set; }

        public DiagramAnalysis(CSET_Context db, int assessment_id)
        {
            this.db = db;
            this.assessment_id = assessment_id;
            imageToTypePath = db.COMPONENT_SYMBOLS.ToDictionary(x => x.File_Name, x => x.Diagram_Type_Xml);
            NetworkWarnings = new List<IDiagramAnalysisNodeMessage>();
        }

        public List<IDiagramAnalysisNodeMessage> PerformAnalysis(XmlDocument xDoc)
        {
            String sal = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessment_id).First().Selected_Sal_Level;
            SimplifiedNetwork network = new SimplifiedNetwork(this.imageToTypePath, sal);
            network.ExtractNetworkFromXml(xDoc);

            List<IDiagramAnalysisNodeMessage> msgs = AnalyzeNetwork(network);
            return msgs;
        }

        public List<IDiagramAnalysisNodeMessage> AnalyzeNetwork(SimplifiedNetwork network)
        {
            List<IRuleEvaluate> rules = new List<IRuleEvaluate>();
            rules.Add(new Rule1(network));
            rules.Add(new Rule2(network));
            rules.Add(new Rule3and4(network));
            rules.Add(new Rule5(network));
            rules.Add(new Rule6(network));
            rules.Add(new Rule7(network));

            List<IDiagramAnalysisNodeMessage> msgs = new List<IDiagramAnalysisNodeMessage>();
            foreach (IRuleEvaluate rule in rules)
            {
                msgs.AddRange(rule.Evaluate());
            }

            // number and persist warning messages
            using (CSET_Context context = new CSET_Context())
            {
                var oldWarnings = context.NETWORK_WARNINGS.Where(x => x.Assessment_Id == assessment_id).ToList();
                context.NETWORK_WARNINGS.RemoveRange(oldWarnings);
                context.SaveChanges();

                int n = 0;
                msgs.ForEach(m =>
                {
                    m.Number = ++n;

                    context.NETWORK_WARNINGS.Add(new NETWORK_WARNINGS
                    {
                        Assessment_Id = assessment_id,
                        Id = m.Number,
                        WarningText = m.Message
                    });

                });

                context.SaveChanges();
            }

            return msgs;
        }

        private void RunAnalysis()
        {

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