//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Business.Diagram.Analysis
{
    public interface IDiagramAnalysisNodeMessage
    {
        string id { get; set; }
        string label { get; set; }
        string layerId { get; set; }
        int Number { get; set; }
        string parent { get; set; }
        string redDot { get; set; }
        string value { get; set; }
        string vertex { get; set; }
        string Message { get; set; }
        int MessageIdentifier { get; set; }
        int Rule_Violated { get; set; }
        string NodeId1 { get; set; }
        string NodeId2 { get; set; }
        HashSet<string> SetMessages { get; set; }
    }
}