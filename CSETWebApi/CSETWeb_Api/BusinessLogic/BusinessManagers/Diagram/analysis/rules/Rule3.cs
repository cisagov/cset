using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule3and4 : IRuleEvaluate
    {
        
        public Rule3and4(SimplifiedNetwork simplifiedNetwork)
        {

        }

        public List<DiagramAnalysisNodeMessage> evaluate()
        {
            throw new NotImplementedException();
        }

        private String rule3 = "The separate subnets handled by the VLAN component, {0}, carry traffic of different SALs.  The incorrect configuration of the component, or the possible compromise of the component, allow the critical traffic to be visible on the less protected network segment.";
        private String rule4 = "The component, {0}, has multiple interfaces where the subnets of those interfaces carry traffic of different SALs.  If the component is compromised, the critical traffic could be visible from the less protected network.";


        ///// <summary>
        ///// rewrite rules  
        ///// 
        ///// </summary>
        ///// <param name="component"></param>
        //private void CheckRule34(NetworkNode component)
        //{
        //    if ((component.Subnets.Count) > 1)
        //    {
        //        List<EdgeNodeInfo> list = GetNodeEdges(component, new HashSet<string>() { Constants.FIREWALL_TYPE, Constants.UNIDIRECTIONAL_TYPE });
        //        int countSALs = list.Select(x => x.EndComponent.SAL.Selected_Sal_Level).Distinct().Count();
        //        if (countSALs > 2)
        //        {
        //            if (component.IsVLAN)
        //            {
        //                String componentName = "unnamed";
        //                if (!String.IsNullOrWhiteSpace(component.TextNodeLabel))
        //                {
        //                    componentName = component.TextNodeLabel;
        //                }

        //                String text = String.Format(rule3, componentName);
        //                SetNodeMessage(component, text);
        //            }
        //            else
        //            {
        //                String componentName = "unnamed";
        //                if (!String.IsNullOrWhiteSpace(component.TextNodeLabel))
        //                {
        //                    componentName = component.TextNodeLabel;
        //                }

        //                String text = String.Format(rule4, componentName);
        //                SetNodeMessage(component, text);
        //            }
        //        }
        //    }
        //}

    }
}
