using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule6 : IRuleEvaluate
    {
        private String rule1 = "The network path identified by the components, {0} and {1}, appears to connect network segments whose components reside in different zones.  A firewall to filter the traffic on this path is recommended to protect the components in one zone from a compromised component in the other zone.";
        public Rule6(SimplifiedNetwork simplifiedNetwork)
        {

        }

        public List<DiagramAnalysisNodeMessage> evaluate()
        {
            throw new NotImplementedException();
        }



        //private String rule6 = "The path between the components, {0} and {1}, is untrusted.  Because malicious traffic may be introduced onto the link, a firewall to filter the traffic on both sides of untrusted link is recommended.";


        //private void CheckRule6(HashSet<Guid> checkedLines, NetworkLink link, NetworkNode headComponent, NetworkNode tailComponent)
        //{
        //    if (link.Security == LinkSecurityEnum.Untrusted)
        //    {
        //        if (headComponent.IsFirewall || tailComponent.IsFirewall)
        //        {
        //            //If there is firewall don't show message
        //        }
        //        else
        //        {
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

        //            String text = String.Format(rule6, headName, tailName);
        //            AddMessage(link, text);
        //        }

        //    }
        //}
    }
}
