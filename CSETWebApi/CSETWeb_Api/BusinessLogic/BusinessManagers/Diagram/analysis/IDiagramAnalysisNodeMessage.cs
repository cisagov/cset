using System.Collections.Generic;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    public interface IDiagramAnalysisNodeMessage
    {
        string id { get; }
        string label { get; }
        string layerId { get; }        
        int Number { get; }
        string parent { get; }
        string redDot { get; }        
        string value { get; }
        string vertex { get; }
        string Message { get; }
        int MessageIdentifier { get; set; }
    }
}