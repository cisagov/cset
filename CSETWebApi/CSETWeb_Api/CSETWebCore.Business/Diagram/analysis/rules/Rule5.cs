//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business;
using CSETWebCore.Business.BusinessManagers.Diagram.analysis;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.Business.Diagram.analysis.rules;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule5 : AbstractRule, IRuleEvaluate
    {
        private String rule5 = "The path identified by the components, {0} and {1}, appears to " +
            "connect on one side to an external network.  A firewall to filter the traffic to and " +
            "from the external network is recommended to protect the facility's network.  " +
            "Note that a 'Web' component, 'Vendor' component, or 'Partner' component are all assumed " +
            "to interface with an external network.  In addition, a modem with a single connection " +
            "is assumed to allow a connection from outside the facility's network.";

        private SimplifiedNetwork network;

        public Rule5(SimplifiedNetwork simplifiedNetwork)
        {
            this.network = simplifiedNetwork;
        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            var partenerVendorWeb = network.Nodes.Values.Where(x => x.IsPartnerVendorOrWeb).ToList();
            foreach (var pvw in partenerVendorWeb)
            {
                CheckRule5(pvw);
            }
            return this.Messages;
        }


        private void CheckRule5(NetworkComponent component)
        {
            HashSet<String> VisitedNodes = new HashSet<string>
            {
                component.ID
            };

            List<NetworkComponent> list = GetNodeEdges(component, new HashSet<int>()
            {
                CSETWebCore.Constants.Constants.FIREWALL
            });

            foreach (NetworkComponent info in list)
            {
                String componentName = "unnamed";
                if (!String.IsNullOrWhiteSpace(component.ComponentName))
                {
                    componentName = component.ComponentName;
                }

                String endComponentName = "unnamed";
                if (!String.IsNullOrWhiteSpace(info.ComponentName))
                {
                    endComponentName = info.ComponentName;
                }

                String text = String.Format(rule5, componentName, endComponentName).Replace("\n", " ");
                SetLineMessage(component, info, text, 5); // 5 because rule5 was violated
            }
        }
    }
}
