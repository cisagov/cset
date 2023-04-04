//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.Analysis;
using System.Collections.Generic;

namespace CSETWebCore.Business.Diagram.analysis.rules
{
    interface IRuleEvaluate
    {
        List<IDiagramAnalysisNodeMessage> Evaluate();
    }
}
