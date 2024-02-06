//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Business;
using CSETWebCore.Business.BusinessManagers.Diagram.analysis;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.Business.Diagram.analysis.rules;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules.MalcolmRules
{
    class Rule9 : AbstractRule, IRuleEvaluate
    {

        private String rule9 = "The subnet should have an IDS (Intrusion Detection System) inline to " +
            "detect if malicious traffic penetrates the firewall.";

        private SimplifiedNetwork network;

        public Rule9(SimplifiedNetwork simplifiedNetwork)
        {
            this.network = simplifiedNetwork;
        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            bool 
            var allNodes = network.Nodes.Values.ToList();
            foreach (var node in allNodes)
            {
                if (node.IsIDS)
                {
                    return this.Messages;
                }
            }

            var firewalls = network.Nodes.Values.Where(x => x.IsFirewall).ToList();
            foreach (var firewall in firewalls)
            {
                Visited.Clear();
                CheckRule9(firewall);
            }
            return this.Messages;
        }

        private HashSet<String> Visited = new HashSet<string>();

        /// <summary>
        /// Check Firewall for IPS and IDS past the firewall
        /// </summary>
        /// <param name="multiServiceComponent"></param>
        /// <param name="visitedNodes"></param>
        private void CheckRule9(NetworkComponent firewall)
        {
            // This code is here because component can be a multiple service component that is IDS
            if (firewall.IsIDS)
            {
                return;
            }

            //recurse through all the edges and see if you can find an ids or ips
            //if it is in the same zone             
            foreach (NetworkComponent child in firewall.Connections)
            {
                if (child.IsInSameZone(firewall))
                {
                    if (child.IsIDS)
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

            String text = String.Format(rule9, componentName).Replace("\n", " ");
            SetNodeMessage(firewall, text, 9); // 9 because rule9 was violated
        }

        private bool RecurseDownConnections(NetworkComponent itemToCheck, NetworkComponent firewall)
        {
            foreach (NetworkComponent child in itemToCheck.Connections)
            {
                if (Visited.Add(child.ID))
                {
                    //Trace.WriteLine("->" + child.ComponentName + ":" + firewall.ComponentName);
                    if (child.IsInSameZone(firewall))
                    {
                        if (child.IsIDS)
                        {
                            //Trace.WriteLine("Found it");
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
