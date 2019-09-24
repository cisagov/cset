using CSETWeb_Api.BusinessManagers.Diagram.Analysis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules
{
    interface IRuleEvaluate
    {
        List<INetworkAnalysisMessage> evaluate();
    }
}
