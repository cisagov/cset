using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    internal abstract class AbstractRule
    {
        private Dictionary<Guid, DiagramAnalysisLineMessage> dictionaryLineMessages = new Dictionary<Guid, DiagramAnalysisLineMessage>();
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

        /// <summary>
        /// TODO fix this to process lines instead of nodes
        /// </summary>
        /// <param name="component1"></param>
        /// <param name="component2"></param>
        /// <param name="text"></param>
        public void SetLineMessage(NetworkNode component1, NetworkNode component2,  string text)
        {
            DiagramAnalysisNodeMessage messageNode;
            //flag node and put up the message
            //if the message is already there over write with the latest edition
            if (dictionaryNodeMessages.ContainsKey(component1.ComponentGuid))
            {
                messageNode = dictionaryNodeMessages[component1.ComponentGuid];
            }
            else
            {
                messageNode = new DiagramAnalysisNodeMessage()
                {
                    Component = (NetworkComponent)component1,
                    NodeId1 = component1.ID,
                    NodeId2 = component2.ID,                    
                    SetMessages = new HashSet<string>()
                };
                dictionaryNodeMessages.Add(component1.ComponentGuid, messageNode);
                IsMessageAdded = true;
            }
            messageNode.AddMessage(text);
        }


        public void SetNodeMessage(NetworkNode component, string text)
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
                    NodeId1 = component.ID
                };
                dictionaryNodeMessages.Add(component.ComponentGuid, messageNode);
                IsMessageAdded = true;
            }
            messageNode.AddMessage(text);
        }

        protected List<NetworkComponent> GetNodeEdges(NetworkComponent component, HashSet<String> typeNodes, HashSet<string> SetVisted = null)
        {
            SetVisted = SetVisted ?? new HashSet<String>();
            SetVisted.Add(component.ID);
            List<NetworkComponent> listInfo = new List<NetworkComponent>();
            GetNodeInfoRecursive(ref listInfo, typeNodes, SetVisted, component);
            return listInfo;
        }

        private void GetNodeInfoRecursive(ref List<NetworkComponent> listNode, HashSet<String> typeNodes, HashSet<string> visitedNodes, NetworkComponent component)
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