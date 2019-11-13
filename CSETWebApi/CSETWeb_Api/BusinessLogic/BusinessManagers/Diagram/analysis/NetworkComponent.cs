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
                return this.Component_Symbol_Id == Constants.UNIDIRECTIONAL_DEVICE;// = 29;
            }
        }

        public NetworkZone Zone { get; internal set; }
        public bool IsFirewall { get
            {
                return this.Component_Symbol_Id == Constants.FIREWALL;// = 29;
                //return string.Equals(this.ComponentType, "Firewall", StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsIDSOrIPS {
            get
            {
                //TODO if this is an MSC
                //look to see if the MSC contains 
                //an ips or ids
                return this.Component_Symbol_Id == Constants.IDS_TYPE || this.Component_Symbol_Id == Constants.IPS_TYPE;

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
                return this.Component_Symbol_Id == Constants.CONNECTOR_TYPE;
            }
        }

        public bool IsVLAN
        {
            get
            {
                return this.Component_Symbol_Id == Constants.VLAN_ROUTER || this.Component_Symbol_Id == Constants.VLAN_SWITTCH;
            }
        }

        public bool IsPartnerVendorOrWeb {
            get
            {
                return this.Component_Symbol_Id == Constants.PARTNER_TYPE
                    || this.Component_Symbol_Id == Constants.VENDOR_TYPE
                    || this.Component_Symbol_Id == Constants.WEB_TYPE;
            }
        }
        public int Component_Symbol_Id { get; internal set; }
        public bool isMultipleConnections { get; internal set; }

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
                    this.Component_Symbol_Id = Constants.ZONE;// 121;
                    break;
                case "parent":
                    this.Parent_id = value;
                    break;

            }
        }

        public bool IsNotComponentTypes(HashSet<int> types)
        {
            //I am concerned about this being case sensitive
            return !types.Contains(this.Component_Symbol_Id);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return string.Format("{0}", this.ComponentName);
        }
    }
}