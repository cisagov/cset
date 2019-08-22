//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Xml;

namespace CSETWeb_Api.BusinessManagers
{
    internal class DiagramAnalysis
    {
        private Dictionary<String, NetworkNode> nodes = new Dictionary<string, NetworkNode>();

        internal void PerformAnalysis(XmlDocument xDoc)
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
            XmlNodeList mxCellNodes = xDoc.SelectNodes("//*[@edge=\"1\"]");
            foreach (XmlNode node in objectNodes)
            {
                //determine if it is an edge or a node
                //if it is an node look it up(should be new)
                //and create it
                //if it is an edge then we need to save it until all the nodes are created
                //once we have them all start connecting everything up. 
                NetworkNode dnode; 
                string id = node.Attributes["id"].Value;
                if (nodes.TryGetValue(id,out dnode))
                {

                }
                else
                {
                    dnode = new NetworkNode()
                    {
                        ComponentGuid = node.Attributes["ComponentGuid"].Value,
                        ID = node.Attributes["id"].Value
                    };
                    nodes.Add(id, dnode);
                }
            }
            foreach (XmlNode node in mxCellNodes)
            {   
                //find each node
                //add them to each other             
                NetworkNode start = findNode(node.Attributes["source"].Value);
                NetworkNode target  = findNode(node.Attributes["target"].Value);
                start.AddEdge(target);
                target.AddEdge(start);
                
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

        
    }
}