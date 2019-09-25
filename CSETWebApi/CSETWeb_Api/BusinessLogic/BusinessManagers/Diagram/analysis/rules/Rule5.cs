using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule5 : AbstractRule, IRuleEvaluate
    {
        private String rule1 = "The network path identified by the components, {0} and {1}, appears to connect network segments whose components reside in different zones.  A firewall to filter the traffic on this path is recommended to protect the components in one zone from a compromised component in the other zone.";
        public Rule5(SimplifiedNetwork simplifiedNetwork)
        {

        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            throw new NotImplementedException();
        }


        //private String rule5 = "The path identified by the components, {0} and {1}, appears to connect on one side to an external network.  A firewall to filter the traffic to and from the external network is recommended to protect the facility's network.  Note that a 'Web' component, 'Vendor' component, or 'Partner' component are all assumed to interface with an external network.  In addition, a modem with a single connection is assumed to allow a connection from outside the facility's network.";

        //private void CheckRule5(NetworkNode component)
        //{
        //    if (component.IsPartnerVendorOrWeb)//Is it Firewall,Vendor,Partner
        //    {
        //        HashSet<Guid> VisitedNodes = new HashSet<Guid>();
        //        VisitedNodes.Add(component.ID);
        //        List<EdgeNodeInfo> list = GetNodeEdges(component, new HashSet<String>() { Constants.FIREWALL_TYPE });
        //        foreach (EdgeNodeInfo info in list)
        //        {
        //            String componentName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(component.TextNodeLabel))
        //            {
        //                componentName = component.TextNodeLabel;
        //            }

        //            String endComponentName = "unnamed";
        //            if (!String.IsNullOrWhiteSpace(info.EndComponent.TextNodeLabel))
        //            {
        //                endComponentName = info.EndComponent.TextNodeLabel;
        //            }

        //            String text = String.Format(rule5, componentName, endComponentName);
        //            AddMessage(info.Link, text);
        //        }
        //    }
        //}

    }
}
