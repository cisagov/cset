namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    public class DiagramAnalysisNodeMessage : DiagramAnalysisBaseMessage
    {
        public NetworkNode Component { get; internal set; }
        public int Number { get; internal set; }
    }
}
