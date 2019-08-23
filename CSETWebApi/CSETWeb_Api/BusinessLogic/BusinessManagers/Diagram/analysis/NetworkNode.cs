using System;
using System.Collections.Generic;
using System.Xml;

namespace CSETWeb_Api.BusinessManagers
{
    internal class NetworkNode
    {
        public string ID { get; set; }
        public string ComponentType { get; set; }
        public Guid ComponentGuid { get; internal set; }
        public List<NetworkNode> Connections { get; set; }
        public bool IsVisible { get; internal set; }
        public bool IsUnidirectional { get; internal set; }
        public string ComponentName { get; internal set; }

        public NetworkNode()
        {
            Connections = new List<NetworkNode>();
        }
        internal void AddEdge(NetworkNode target)
        {
            Connections.Add(target);
        }

        internal bool IsInSameZone(NetworkNode tailComponent)
        {
            throw new NotImplementedException();
        }
    }
}