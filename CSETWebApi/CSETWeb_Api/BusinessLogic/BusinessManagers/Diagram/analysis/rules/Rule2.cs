using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule2 : AbstractRule, IRuleEvaluate
    {

        private String rule2 = "The subnet should have an IDS (Intrusion Detection System) or " +
            "IPS (Intrusion Prevention System) inline to confirm that the configuration of firewall, " +
            "{0}, is correct and that malware has not been able to penetrate past the firewall.";

        private SimplifiedNetwork network;

        public Rule2(SimplifiedNetwork simplifiedNetwork)
        {
            this.network = simplifiedNetwork;
        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            var firewalls = network.Nodes.Values.Where(x => x.IsFirewall).ToList();
            foreach (var firewall in firewalls)
            {
                CheckRule2(firewall);
            }
            return this.Messages;
        }

        private HashSet<String> notYetVisited = new HashSet<string>();

        /// <summary>
        /// Check Firewall for IPS and IDS past the firewall
        /// </summary>
        /// <param name="multiServiceComponent"></param>
        /// <param name="visitedNodes"></param>
        private void CheckRule2(NetworkComponent firewall)
        {
            // This code is here because component can be a multiple service component that is IDS and IPS
            if (firewall.IsIDSOrIPS)
            {
                return;
            }

            //recurse through all the edges and see if you can find an ids or ips
            //if it is in the same zone             
            foreach (NetworkComponent child in firewall.Connections)
            {
                if (child.IsInSameZone(firewall))
                {
                    if (child.IsIDSOrIPS)
                    {
                        return;
                    }
                    else if (RecurseDownConnections(child, firewall))
                    {
                        return;
                    }
                }
            }

            String componentName = "unnamed";
            if (!String.IsNullOrWhiteSpace(firewall.ComponentName))
            {
                componentName = firewall.ComponentName;
            }

            String text = String.Format(rule2, componentName).Replace("\n", " ");
            SetNodeMessage(firewall, text);
        }

        private bool RecurseDownConnections(NetworkComponent itemToCheck, NetworkComponent firewall)
        {
            foreach (NetworkComponent child in itemToCheck.Connections)
            {
                if (notYetVisited.Add(child.ID))
                {
                    if (child.IsInSameZone(firewall))
                    {
                        if (child.IsIDSOrIPS)
                        {
                            return true;
                        }
                        else if (RecurseDownConnections(child, firewall))
                        {
                            return true;
                        }
                    }
                }
            }

            return false;
        }
    }
}
