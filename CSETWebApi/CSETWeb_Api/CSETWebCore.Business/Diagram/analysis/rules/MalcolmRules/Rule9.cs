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
using CSETWebCore.Model.Diagram;
using DocumentFormat.OpenXml.Drawing.Charts;

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
            CheckRule9();
            return this.Messages;
        }

        /// <summary>
        /// Check for IDS (Malcolm can't passively detect a firewall,
        /// so we don't worry about how the IDS is connected)
        /// </summary>
        private void CheckRule9()
        {
            bool idsDetected = false;
            var allNodes = network.Nodes.Values.ToList();
            foreach (var node in allNodes)
            {
                if (node.IsIDS)
                {
                    idsDetected = true;
                }
            }

            if (!idsDetected)
            {
                String text = String.Format(rule9, allNodes[0].ComponentName).Replace("\n", " ");
                SetNodeMessage(allNodes[0], text, 9); // 9 because rule9 was violated
            }
        }

    }
}
