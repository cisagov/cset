using System;
using System.Collections.Generic;
using System.Xml;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessManagers
{
    public class NetworkComponent : NetworkNode
    {
        public List<NetworkComponent> Connections { get; set; }
        public bool IsUnidirectional { get; internal set; }
        
        public NetworkComponent()
        {
            Connections = new List<NetworkComponent>();
            ParentChanged = false;
        }
        internal void AddEdge(NetworkComponent target)
        {
            Connections.Add(target);
        }

        internal bool IsInSameZone(NetworkComponent tailComponent)
        {
            throw new NotImplementedException();
        }

        //public string label { get; set; }
        
        //public string id { get; set; }
        //public string Component_Type { get; internal set; }
        //public string Parent_id { get; private set; }

        public void setValue(string name, string value)
        {
            switch (name)
            {
                case "label":
                    this.ComponentName = value;
                    break;
                case "ComponentGuid":
                    this.ComponentGuid = new Guid(value);
                    break;
                case "id":
                    this.ID = value;
                    break;               
                case "zone":
                    this.ComponentType = "Zone";
                    break;
                case "parent":
                    this.Parent_id = value;
                    break;

            }
        }
    }
}