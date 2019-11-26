using CSETWeb_Api.BusinessManagers.Diagram.Analysis;

namespace CSETWeb_Api.BusinessManagers
{
    public class FullNode
    {
        public NetworkComponent Source { get; set; }
        public NetworkComponent Target { get; set; }
        public NetworkLink Link { get; set; }
    }
}