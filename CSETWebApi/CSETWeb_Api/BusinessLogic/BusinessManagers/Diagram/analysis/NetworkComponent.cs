using System;
using System.Collections.Generic;
using System.Xml;
using BusinessLogic.Helpers;
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
                return string.Equals(this.ComponentType, "Unidirectional Device", StringComparison.OrdinalIgnoreCase);
            }
        }

        public NetworkZone Zone { get; internal set; }
        public bool IsFirewall { get
            {
                return string.Equals(this.ComponentType, "Firewall", StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsIDSOrIPS {
            get
            {
                //TODO if this is an MSC
                //look to see if the MSC contains 
                //an ips or ids
                return string.Equals(this.ComponentType, Constants.IDS_TYPE, StringComparison.OrdinalIgnoreCase)
                    || string.Equals(this.ComponentType, Constants.IPS_TYPE, StringComparison.OrdinalIgnoreCase);

            }
        }

        public bool IsFirewallUnidirectional {
            get
            {
                return IsFirewall || IsUnidirectional;
            }
        }

        public bool IsLinkConnector {
            get
            {
                return string.Equals(this.ComponentType, Constants.CONNECTOR_TYPE, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsVLAN
        {
            get
            {
                return string.Equals(this.ComponentType, Constants.VLAN_ROUTER, StringComparison.OrdinalIgnoreCase)
                    || string.Equals(this.ComponentType, Constants.VLAN_SWITTCH, StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsPartnerVendorOrWeb { get; internal set; }

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

        public bool IsNotComponentTypes(HashSet<string> types)
        {
            //I am concerned about this being case sensitive
            return !types.Contains(this.ComponentType);
        }
    }
}