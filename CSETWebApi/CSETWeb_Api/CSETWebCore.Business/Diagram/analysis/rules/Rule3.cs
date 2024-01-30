//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Business;
using CSETWebCore.Business.BusinessManagers.Diagram.analysis;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.Business.Diagram.analysis.rules;
using CSETWebCore.Constants;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule3and4 : AbstractRule, IRuleEvaluate
    {

        public Rule3and4(SimplifiedNetwork simplifiedNetwork)
        {
            this.network = simplifiedNetwork;
        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            var firewalls = network.Nodes.Values.Where(x => !x.IsFirewallUnidirectional && x.isMultipleConnections).ToList();
            foreach (var firewall in firewalls)
            {
                CheckRule34(firewall);
            }
            return this.Messages;
        }

        private String rule3 = "The separate subnets handled by the VLAN component, {0}, carry traffic " +
            "of different SALs.  The incorrect configuration of the component, or the possible compromise " +
            "of the component, allow the critical traffic to be visible on the less protected network segment.";

        private String rule4 = "The component, {0}, has multiple interfaces where the subnets of those " +
            "interfaces carry traffic of different SALs.  If the component is compromised, the critical traffic " +
            "could be visible from the less protected network.";

        private SimplifiedNetwork network;


        /// <summary>
        /// rewrite rules  
        /// 
        /// </summary>
        /// <param name="component"></param>
        private void CheckRule34(NetworkComponent component)
        {
            List<NetworkComponent> list = GetNodeEdges(component,
                new HashSet<int>() {
                    Constants.FIREWALL,
                    Constants.UNIDIRECTIONAL_DEVICE,
                    Constants.IDS_TYPE,
                    Constants.IPS_TYPE,
                    Constants.SERIAL_RADIO
                });

            int countSALs = list.Select(x => x.Zone.SAL).Distinct().Count();
            if (countSALs > 1)
            {
                if (component.IsVLAN)
                {
                    String componentName = "unnamed";
                    if (!String.IsNullOrWhiteSpace(component.ComponentName))
                    {
                        componentName = component.ComponentName;
                    }

                    String text = String.Format(rule3, componentName).Replace("\n", " ");
                    SetNodeMessage(component, text, 3); // 3 because rule3 was violated
                }
                else
                {
                    String componentName = "unnamed";
                    if (!String.IsNullOrWhiteSpace(component.ComponentName))
                    {
                        componentName = component.ComponentName;
                    }

                    String text = String.Format(rule4, componentName).Replace("\n", " ");
                    SetNodeMessage(component, text, 4); // 4 because rule4 was violated
                }
            }
        }
    }
}
