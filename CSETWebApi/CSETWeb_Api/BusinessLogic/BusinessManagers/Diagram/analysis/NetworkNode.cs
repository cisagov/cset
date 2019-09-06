using System;
using System.Collections.Generic;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessManagers
{
    public abstract class NetworkNode
    {
        public string ID { get; set; }
        public string ComponentType { get; set; }
        public Guid ComponentGuid { get; internal set; }
        public bool IsVisible { get; internal set; }
        public string ComponentName { get; internal set; }
        public NetworkGeometry Geometry { get; internal set; }
        public string LayerId { get; internal set; }
    }
}