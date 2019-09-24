using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule2 : IRuleEvaluate
    {
        
        private String rule2 = "The subnet, {0}, should have an IDS (Intrusion Detection System) or IPS (Intrusion Prevention System) inline to confirm that the configuration of firewall, {1}, is correct and that malware has not been able to penetrate past the firewall.";

        public Rule2(SimplifiedNetwork simplifiedNetwork)
        {

        }

        public List<DiagramAnalysisNodeMessage> evaluate()
        {
            throw new NotImplementedException();
        }


        ///// <summary>
        ///// Check Firewall for IPS and IDS past the firewall
        ///// </summary>
        ///// <param name="multiServiceComponent"></param>
        ///// <param name="visitedNodes"></param>
        //private void CheckRule2(NetworkNode firewall)
        //{
        //    if (firewall.IsIDSOrIPS) // This code is here because component can be a multiple service component that is IDS and IPS
        //    {
        //        return;
        //    }

        //    List<EdgeNodeInfo> list = GetNodeEdges(firewall, new HashSet<string>());
        //    foreach (EdgeNodeInfo info in list)
        //    {
        //        if (info.EndComponent.IsInSameZone(firewall))
        //        {
        //            if (info.EndComponent.IsIDSOrIPS)
        //            {
        //                return;
        //            }
        //        }
        //    }
        //    string subnet = "";

        //    HashSet<String> subnets = firewall.Subnets;
        //    if (subnets.Count > 0)
        //        subnet = subnets.ToList<String>()[0];
        //    else
        //        subnet = "unnamed";

        //    String componentName = "unnamed";
        //    if (!String.IsNullOrWhiteSpace(firewall.TextNodeLabel))
        //    {
        //        componentName = firewall.TextNodeLabel;
        //    }

        //    String text = String.Format(rule2, subnet, componentName);
        //    SetNodeMessage(firewall, text);
        //}
    }
}
