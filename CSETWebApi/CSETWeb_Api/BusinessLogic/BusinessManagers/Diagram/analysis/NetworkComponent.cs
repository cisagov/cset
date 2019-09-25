using System;
using System.Collections.Generic;
using System.Xml;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.Analysis;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessManagers
{
    public class NetworkComponent : NetworkNode
    {
        public List<NetworkComponent> Connections { get; set; }
        public bool IsUnidirectional {
            get
            {
                return (this.ComponentType == "Unidirectional Device");
            }
        }

        public NetworkZone Zone { get; internal set; }

        public NetworkComponent()
        {
            Connections = new List<NetworkComponent>();
            ParentChanged = false;
        }
        internal void AddEdge(NetworkComponent target)
        {
            if (target == null)
            {
                return;
            }
            Connections.Add(target);
        }

        internal bool IsInSameZone(NetworkComponent tailComponent)
        {
            return (tailComponent.Parent_id == this.Parent_id);
        }

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