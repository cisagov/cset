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
using NPOI.POIFS.Properties;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules.MalcolmRules
{
    class Rule8 : AbstractRule, IRuleEvaluate
    {

        private String rule8 = "The subnet should have an IPS (Intrusion Prevention System) inline to " +
            "provide a swift response if malicious traffic penetrates the firewall.";

        private SimplifiedNetwork network;

        public Rule8(SimplifiedNetwork simplifiedNetwork)
        {
            this.network = simplifiedNetwork;
        }

        public List<IDiagramAnalysisNodeMessage> Evaluate()
        {
            CheckRule8();
            return this.Messages;
        }


        /// <summary>
        /// Check for IPS (Malcolm can't passively detect a firewall,
        /// so we don't worry about how the IPS is connected)
        /// </summary>
        private void CheckRule8()
        {
            bool ipsDetected = false;
            var allNodes = network.Nodes.Values.ToList();
            foreach (var node in allNodes)
            {
                if (node.IsIPS)
                {
                    ipsDetected = true;
                }
            }

            if (!ipsDetected)
            {
                String text = String.Format(rule8, allNodes[0].ComponentName).Replace("\n", " ");
                SetNodeMessage(allNodes[0], text, 8); // 8 because rule8 was violated
            }
        }

    }
}
