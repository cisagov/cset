//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.Business.Diagram.analysis.rules;

namespace CSETWebCore.Business
{
    public class NetworkComponent : NetworkNode
    {
        public List<NetworkComponent> Connections { get; set; }
        public List<FullNode> FullyConnectedConnections { get; set; }
        public bool IsUnidirectional
        {
            get
            {
                return this.Component_Symbol_Id == Constants.Constants.UNIDIRECTIONAL_DEVICE;// = 29;
            }
        }

        public NetworkZone Zone { get; internal set; }
        public bool IsFirewall
        {
            get
            {
                return this.Component_Symbol_Id == Constants.Constants.FIREWALL;// = 29;
                //return string.Equals(this.ComponentType, "Firewall", StringComparison.OrdinalIgnoreCase);
            }
        }

        public bool IsIDSOrIPS
        {
            get
            {
                return this.Component_Symbol_Id == Constants.Constants.IDS_TYPE || this.Component_Symbol_Id == Constants.Constants.IPS_TYPE;
            }
        }

        public bool IsIPS
        {
            get
            {
                return this.Component_Symbol_Id == Constants.Constants.IPS_TYPE;

            }
        }

        public bool IsIDS
        {
            get
            {
                return this.Component_Symbol_Id == Constants.Constants.IDS_TYPE;

            }
        }

        public bool IsFirewallUnidirectional
        {
            get
            {
                return IsFirewall || IsUnidirectional;
            }
        }

        public bool IsLinkConnector
        {
            get
            {
                return this.Component_Symbol_Id == Constants.Constants.CONNECTOR_TYPE;
            }
        }

        public bool IsVLAN
        {
            get
            {
                return this.Component_Symbol_Id == Constants.Constants.VLAN_ROUTER || this.Component_Symbol_Id == Constants.Constants.VLAN_SWITTCH;
            }
        }

        public bool IsPartnerVendorOrWeb
        {
            get
            {
                return this.Component_Symbol_Id == Constants.Constants.PARTNER_TYPE
                    || this.Component_Symbol_Id == Constants.Constants.VENDOR_TYPE
                    || this.Component_Symbol_Id == Constants.Constants.WEB_TYPE;
            }
        }
        //public int Component_Symbol_Id { get; internal set; }
        public bool isMultipleConnections { get; internal set; }

        public NetworkComponent()
        {
            Connections = new List<NetworkComponent>();
            FullyConnectedConnections = new List<FullNode>();
            ParentChanged = false;
        }
        internal void AddEdge(NetworkComponent target, NetworkLink link)
        {
            if (target == null)
            {
                return;
            }
            ComponentPairing t = new ComponentPairing()
            {
                Source = this.ComponentGuid,
                Target = target.ComponentGuid
            };

            Connections.Add(target);
            FullyConnectedConnections.Add(new FullNode() { Source = this, Target = target, Link = link });
        }

        internal bool IsInSameZone(NetworkComponent tailComponent)
        {
            return (tailComponent.Parent_id == this.Parent_id);
        }

        public new void SetValue(string name, string value)
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
                    this.Component_Symbol_Id = Constants.Constants.ZONE;// 121;
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