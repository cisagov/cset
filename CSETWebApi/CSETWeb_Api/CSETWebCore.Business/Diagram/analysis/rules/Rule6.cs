//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using CSETWebCore.Business;
using CSETWebCore.Business.BusinessManagers.Diagram.analysis;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.Business.Diagram.analysis.rules;
using CSETWebCore.Constants;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule6 : AbstractRule, IRuleEvaluate
    {
        private SimplifiedNetwork network;

        public Rule6(SimplifiedNetwork simplifiedNetwork)
        {
            this.network = simplifiedNetwork;
        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            foreach (var edge in this.network.Edges)
            {
                CheckRule6(edge);
            }
            return this.Messages;

        }

        private String rule6 = "The path between the components, {0} and {1}, is untrusted.  " +
            "Because malicious traffic may be introduced onto the link, a firewall to filter the " +
            "traffic on both sides of untrusted link is recommended.  Or encrypt the link to make it trusted.";


        private void CheckRule6(NetworkLink link)
        {
            NetworkComponent headComponent = link.SourceComponent;
            NetworkComponent tailComponent = link.TargetComponent;
            if ((headComponent == null) || (tailComponent == null))
                return;
            if (link.Security == Constants.UnTrusted)
            {
                if (headComponent.IsFirewall || tailComponent.IsFirewall)
                {
                    //If there is firewall don't show message
                }
                else
                {
                    String headName = "unnamed";
                    if (!String.IsNullOrWhiteSpace(headComponent.ComponentName))
                    {
                        headName = headComponent.ComponentName;
                    }

                    String tailName = "unnamed";
                    if (!String.IsNullOrWhiteSpace(tailComponent.ComponentName))
                    {
                        tailName = tailComponent.ComponentName;
                    }

                    String text = String.Format(rule6, headName, tailName).Replace("\n", " ");
                    SetLineMessage(headComponent,tailComponent, text, 6); // 6 because rule6 was violated
                }
            }
        }
    }
}
