using System.Collections.Generic;

namespace CSETWebCore.Business.Diagram.Analysis
{
    public interface IDiagramAnalysisNodeMessage
    {
        string id { get; }
        string label { get; }
        string layerId { get; }        
        int Number { get; set; }
        string parent { get; }
        string redDot { get; }        
        string value { get; }
        string vertex { get; }
        string Message { get; }
        int MessageIdentifier { get; set; }
        string NodeId1 { get; }
        string NodeId2 { get; }
        HashSet<string> SetMessages { get; set; }
    }
}