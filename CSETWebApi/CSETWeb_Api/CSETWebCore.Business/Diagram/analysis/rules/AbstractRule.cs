//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.analysis.helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Diagram.Analysis;

namespace CSETWebCore.Business.Diagram.analysis.rules
{
    internal abstract class AbstractRule
    {
        private Dictionary<ComponentPairing, DiagramAnalysisNodeMessage> dictionaryLineMessages = new Dictionary<ComponentPairing, DiagramAnalysisNodeMessage>();
        private Dictionary<Guid, DiagramAnalysisNodeMessage> dictionaryNodeMessages = new Dictionary<Guid, DiagramAnalysisNodeMessage>();
        private bool IsMessageAdded = false;
        private List<IDiagramAnalysisNodeMessage> allMessages = new List<IDiagramAnalysisNodeMessage>();


        public List<IDiagramAnalysisNodeMessage> Messages
        {
            get
            {
                if (IsMessageAdded)
                {
                    var lineMsgs = dictionaryLineMessages.Values.Cast<IDiagramAnalysisNodeMessage>();
                    var more = lineMsgs.Union(dictionaryNodeMessages.Values.Cast<IDiagramAnalysisNodeMessage>());
                    allMessages.AddRange(more);
                    IsMessageAdded = false;
                }
                return allMessages;
            }
        }


        /// <param name="component1"></param>
        /// <param name="component2"></param>
        /// <param name="text"></param>
        public void SetLineMessage(NetworkNode component1, NetworkNode component2, string text, int ruleViolated)
        {
            DiagramAnalysisNodeMessage messageNode;
            //flag node and put up the message
            //if the message is already there over write with the latest edition
            ComponentPairing pair = (new ComponentPairing()
            {
                Source = component1.ComponentGuid,
                Target = component2.ComponentGuid
            });

            if (dictionaryLineMessages.ContainsKey(pair))
            {
                return;// messageNode = dictionaryNodeMessages[component2.ComponentGuid];
            }

            //
            string appropriateEdgeId = findEdgeId(component1, component2, pair);

            messageNode = new DiagramAnalysisNodeMessage()
            {

                Component = (NetworkComponent)component1,
                NodeId1 = component1.ID,
                NodeId2 = component2.ID,
                edgeId = appropriateEdgeId,
                SetMessages = new HashSet<string>(),
                Rule_Violated = ruleViolated
            };

            dictionaryLineMessages.Add(pair, messageNode);
            IsMessageAdded = true;
            messageNode.AddMessage(text);
        }

        private string findEdgeId(NetworkNode component1, NetworkNode component2, ComponentPairing pair)
        {
            //if we didn't find it here then it's a connector and we need to walk the tree. 
            //We will need to walk the tree and find the node we are looking for
            //printGraph(new List<NetworkComponent>(component1));
            NetworkWalk printer = new NetworkWalk();
            NetworkLink link = printer.FindNodeEdge(component1, component2);

            return link.ID;
        }

        public void SetNodeMessage(NetworkNode component, string text, int ruleViolated)
        {
            DiagramAnalysisNodeMessage messageNode;
            //flag node and put up the message
            //if the message is already there over write with the latest edition
            if (dictionaryNodeMessages.ContainsKey(component.ComponentGuid))
            {
                messageNode = dictionaryNodeMessages[component.ComponentGuid];
            }
            else
            {
                messageNode = new DiagramAnalysisNodeMessage()
                {
                    Component = (NetworkComponent)component,
                    SetMessages = new HashSet<string>(),
                    NodeId1 = component.ID,
                    Rule_Violated = ruleViolated
                };
                dictionaryNodeMessages.Add(component.ComponentGuid, messageNode);
                IsMessageAdded = true;
            }
            messageNode.AddMessage(text);
        }


        protected List<NetworkComponent> GetNodeEdges(NetworkComponent component, HashSet<int> typeNodes, HashSet<string> SetVisted = null)
        {
            SetVisted = SetVisted ?? new HashSet<String>();
            SetVisted.Add(component.ID);
            List<NetworkComponent> listInfo = new List<NetworkComponent>();
            GetNodeInfoRecursive(ref listInfo, typeNodes, SetVisted, component);
            return listInfo;
        }


        private void GetNodeInfoRecursive(ref List<NetworkComponent> listNode, HashSet<int> typeNodes, HashSet<string> visitedNodes, NetworkComponent component)
        {
            foreach (NetworkComponent edge in component.Connections)
            {
                if (CheckAddVisited(visitedNodes, edge))
                    continue;
                //Debug.WriteLine("Visited:");
                // visitedNodes.ToList().ForEach(x => Debug.WriteLine(x.ToString() + "\n"));

                if (edge.IsLinkConnector)
                {
                    GetNodeInfoRecursive(ref listNode, typeNodes, visitedNodes, edge);
                }
                else
                {
                    if (edge.IsNotComponentTypes(typeNodes))
                    {
                        listNode.Add(edge);
                    }
                }
            }
        }


        private bool CheckAddVisited(HashSet<String> visitedNodes, NetworkComponent otherComponent)
        {
            if (visitedNodes.Contains(otherComponent.ID))
                return true;
            else
            {
                visitedNodes.Add(otherComponent.ID);
                return false;
            }
        }
    }
}