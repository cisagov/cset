//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Xml;

namespace CSETWeb_Api.BusinessManagers
{
    internal class DiagramAnalysis
    {
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


        }
    }
}