//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.Analysis;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Diagram
{
    public class Diagram
    {
        public Dictionary<Guid, NetworkComponent> NetworkComponents { get; set; }

        public Dictionary<string, NetworkLayer> Layers { get; private set; }
        public Dictionary<string, NetworkZone> Zones { get; private set; }
        public Dictionary<string, string> OldParentIds { get; internal set; }

        public Dictionary<string, string> Parentage { get; internal set; }

        public Diagram()
        {
            NetworkComponents = new Dictionary<Guid, NetworkComponent>();
            Layers = new Dictionary<string, NetworkLayer>();
            Zones = new Dictionary<string, NetworkZone>();
        }

        internal IEnumerable<NetworkComponent> getParentChanges()
        {
            return NetworkComponents.Values.Where(x => x.ParentChanged);
        }

        internal IEnumerable<NetworkZone> getParentChangesZones()
        {
            return Zones.Values.Where(x => x.ParentChanged).ToList();
        }
    }
}
