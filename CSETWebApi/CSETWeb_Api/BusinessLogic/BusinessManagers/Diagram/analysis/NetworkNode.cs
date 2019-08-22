using System;
using System.Collections.Generic;
using System.Xml;

namespace CSETWeb_Api.BusinessManagers
{
    internal class NetworkNode
    {
        public string ID { get; set; }
        public string ComponentType { get; set; }
        public string ComponentGuid { get; internal set; }
        public List<NetworkNode> Connections { get; set; }

        public NetworkNode()
        {
            Connections = new List<NetworkNode>();
        }
        internal void AddEdge(NetworkNode target)
        {
            Connections.Add(target);
        }
    }
}