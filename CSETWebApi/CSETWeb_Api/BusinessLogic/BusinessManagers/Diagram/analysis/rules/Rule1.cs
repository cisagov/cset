using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.Analysis;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    internal class Rule1 : AbstractRule, IRuleEvaluate
    {
        private Dictionary<String, NetworkComponent> nodes = new Dictionary<string, NetworkComponent>();
        private List<NetworkLink> Links = new List<NetworkLink>();
        private List<NetworkAnalysisNode> ListAnalysisNodes = new List<NetworkAnalysisNode>();
        private Dictionary<string, NetworkLayer> layers = new Dictionary<string, NetworkLayer>();
        //drawio id to zone lookup
        private Dictionary<string, NetworkZone> zones = new Dictionary<string, NetworkZone>();               
        private List<IDiagramAnalysisNodeMessage> NetworkWarnings = new List<IDiagramAnalysisNodeMessage>();

        private int nextMessage = 1;

        private String rule1 = "The network path identified by the components, {0} and {1}, appears to connect network segments whose components reside in different zones.  A firewall to filter the traffic on this path is recommended to protect the components in one zone from a compromised component in the other zone.";
        public Rule1(SimplifiedNetwork simplifiedNetwork)
        {
            this.nodes = simplifiedNetwork.Nodes;
        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            checkRule1();
            return this.Messages;
        }


        private void checkRule1()
        {
            //get the list of vendors, partners, or web
            //if the vendor, partner, or web is connected to anything other than a firewall
            //add a message and let the user know.
            List<string> suspects = new List<string>();
            suspects.Add("Web");
            suspects.Add("Vendor");
            suspects.Add("Partner");
            var suspectslist = nodes.Values.Where(x => suspects.Contains(x.ComponentType));
            foreach (var node in suspectslist)
            {
                foreach (var child in node.Connections)
                {
                    if (child.ComponentType != "Firewall")
                    {
                        String text = String.Format(rule1, node.ComponentName, child.ComponentName);
                        SetLineMessage(node,child, text);
                    }
                }
            }
        }

        //private void CheckRule12(NetworkLink link, NetworkNode headComponent, NetworkNode tailComponent)
        //{
        //    if (!headComponent.IsInSameZone(tailComponent))
        //    {
        //        //Debug.WriteLine("HeadComponent: " + headComponent.Node.ID + " " + headComponent.Node.Label);
        //        //Debug.WriteLine("tailComponent: " + tailComponent.Node.ID + " " + tailComponent.Node.Label);

        //        //Get All components that are not firewalls or unidirectional devices not connectors on head side of edge
        //        List<EdgeNodeInfo> listHead = CheckFirewallUni(link, headComponent, new HashSet<Guid>() { tailComponent.ID });

        //        //Get All that are not firewalls or unidirectional devices components that are not connectors on tail side of edge
        //        List<EdgeNodeInfo> listTail = CheckFirewallUni(link, tailComponent, new HashSet<Guid>() { headComponent.ID });

        //        //If one of these lists is empty then has sufficient filter because it means all the nodes on one
        //        //side have a firewall
        //        bool isFilterTrafficHead = listHead.Count == 0;
        //        bool isFilterTrafficTail = listTail.Count == 0;

        //        if (isFilterTrafficTail || isFilterTrafficHead)
        //            return;
        //        else
        //        {
        //            foreach (EdgeNodeInfo info in listHead)
        //            {
        //                if (info.EndComponent.IsPartnerVendorOrWeb)
        //                {
        //                    return;
        //                }
        //            }
        //            foreach (EdgeNodeInfo info in listTail)
        //            {
        //                if (info.EndComponent.IsPartnerVendorOrWeb)
        //                {
        //                    return;
        //                }
        //            }

        //            String headName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(headComponent.TextNodeLabel))
        //            {
        //                headName = headComponent.TextNodeLabel;
        //            }

        //            String tailName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(tailComponent.TextNodeLabel))
        //            {
        //                tailName = tailComponent.TextNodeLabel;
        //            }

        //            String text = String.Format(rule1, headName, tailName);
        //            AddMessage(link, text);
        //        }
        //    }

        //    if (headComponent.IsFirewall)
        //    {
        //        CheckRule2(headComponent);
        //    }

        //    if (tailComponent.IsFirewall)
        //    {
        //        CheckRule2(tailComponent);
        //    }
        //}

    }
}
