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
using CSETWebCore.DataLayer.Model;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    class Rule7 : AbstractRule, IRuleEvaluate
    {
        private String rule7 = "Data flow between two distinct SAL zones via a unidirectional {0} must only flow from a higher SAL to a lower SAL." +
            " Example Control or SCADA network SAL High to Corporate Network SAL Low, but not SAL Low to SAL High." +
            " Unless the component is in a classified zone, then information can flow in but not out.";

        private static Dictionary<string, UNIVERSAL_SAL_LEVEL> sals = null;
        private SimplifiedNetwork simplifiedNetwork;

        static Rule7()
        {
            // sals = context.UNIVERSAL_SAL_LEVEL.ToDictionary(x => x.Full_Name_Sal.ToLower(), x => x);
        }


        public Rule7(SimplifiedNetwork simplifiedNetwork, CSETContext context)
        {
            sals = context.UNIVERSAL_SAL_LEVEL.ToDictionary(x => x.Full_Name_Sal.ToLower(), x => x);
            this.simplifiedNetwork = simplifiedNetwork;
        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            var unidirectional = this.simplifiedNetwork.Nodes.Values.Where(x => x.IsUnidirectional);
            foreach (var comp in unidirectional.ToList())
            {
                CheckRule7(comp);
            }
            return this.Messages;
        }

        /// <summary>
        /// rewriting the rules to make more sense  NOTE the data flows in the direction of the arrow
        /// so for this one we need to determine orientation of the device
        /// we want to recurse up into the network from the connections and 
        /// see if we can find some control system devices if we can 
        /// then data should only flow out of the control system side of the data diode
        /// if we find control systems components on both sides we should warn and have the user resolve it. 
        /// maybe we should popup a dialog to determine how to analyse the network
        /// 
        /// ie if this is classified then data should flow in 
        /// if this is control systems network it should flow out 
        /// </summary>
        /// <param name="component"></param>
        private void CheckRule7(NetworkComponent component)
        {
            if (component.IsUnidirectional)
            {
                //determine the zone type of the zone the unidirectional device
                //is in if the zone is anything but classified information 
                //should flow from high to low

                bool isHighToLow = true;
                //if it is a classified zone it should flow from low to high
                if (component.Zone != null)
                    if (component.Zone.ZoneType == "Classified")
                    {
                        //must flow from low to high
                        isHighToLow = false;
                    }
                //else must flow from high to low


                //look to see if the items connected are in the same zone
                //if they are not then start moving out
                //if items are not in my same zone 
                foreach (NetworkComponent link in component.Connections)
                {
                    if (component.IsInSameZone(link))
                    {
                        continue;
                    }
                    bool isComponentConnectionValid = true;
                    UNIVERSAL_SAL_LEVEL componentSal = sals[component.Zone.SAL.ToLower()];
                    UNIVERSAL_SAL_LEVEL targetSal = sals[link.Zone.SAL.ToLower()];

                    if (isHighToLow)
                        isComponentConnectionValid = componentSal.Sal_Level_Order > targetSal.Sal_Level_Order;
                    else
                        isComponentConnectionValid = componentSal.Sal_Level_Order < targetSal.Sal_Level_Order;

                    String componentName = "unnamed";
                    if (!String.IsNullOrWhiteSpace(component.ComponentName))
                    {
                        componentName = component.ComponentName;
                    }

                    if (!isComponentConnectionValid)
                    {
                        String text = String.Format(rule7, componentName).Replace("\n", " ");
                        SetLineMessage(component, link, text, 7); // 7 because rule7 was violated
                    }
                }
            }
        }
    }
}
