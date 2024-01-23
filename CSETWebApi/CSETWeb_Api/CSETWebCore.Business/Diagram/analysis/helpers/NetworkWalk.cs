//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Diagnostics;
using CSETWebCore.Business.Diagram.Analysis;

namespace CSETWebCore.Business.Diagram.analysis.helpers
{
    public class NetworkWalk
    {
        private HashSet<NetworkComponent> alreadySeenNodes = new HashSet<NetworkComponent>();

        public void printGraph(List<NetworkComponent> nodes)
        {
            alreadySeenNodes.Clear();
            foreach (NetworkComponent n in nodes)
            {
                if (!alreadySeenNodes.Contains(n))
                    printNode(n, 0);
            }
        }

        private void printNode(NetworkComponent top, int indent)
        {
            Trace.Write(new String('\t', indent));
            Trace.WriteLine("-->" + top.ID + ":" + top.ComponentName);
            int nextIndent = indent + 1;
            alreadySeenNodes.Add(top);
            foreach (FullNode f in top.FullyConnectedConnections)
            {
                if (!alreadySeenNodes.Contains(f.Target))
                    printNode(f.Target, nextIndent);
            }
        }

        public void printGraphSimple(List<NetworkComponent> nodes)
        {
            alreadySeenNodes.Clear();
            foreach (NetworkComponent n in nodes)
            {
                if (!alreadySeenNodes.Contains(n))
                    printNodeSimple(n, 0);
            }
        }

        private void printNodeSimple(NetworkComponent top, int indent)
        {
            Trace.Write(new String('\t', indent));
            Trace.WriteLine("-->" + top.ID + ":" + top.ComponentName);
            int nextIndent = indent + 1;
            alreadySeenNodes.Add(top);
            foreach (NetworkComponent f in top.Connections)
            {
                if (!alreadySeenNodes.Contains(f))
                    printNode(f, nextIndent);
            }
        }

        internal NetworkLink FindNodeEdge(NetworkNode component1, NetworkNode component2)
        {

            //printNode((NetworkComponent)component1, 0);
            alreadySeenNodes.Clear();
            return findNode((NetworkComponent)component1, (NetworkComponent)component2);
        }

        private NetworkLink findNode(NetworkComponent top, NetworkComponent target)
        {
            alreadySeenNodes.Add(top);
            foreach (FullNode f in top.FullyConnectedConnections)
            {
                if (f.Target == target)
                {
                    return f.Link;
                }
                if (!alreadySeenNodes.Contains(f.Target))
                {
                    var node = findNode(f.Target, target);
                    if (node != null)
                        return node;
                }
            }
            return null;
        }
    }
}
