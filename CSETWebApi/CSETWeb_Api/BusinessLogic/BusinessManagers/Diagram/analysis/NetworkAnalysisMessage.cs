using System;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    public class NetworkAnalysisMessage : INetworkAnalysisMessage
    {
        public String Message { get; set; }
        public int MessageIdentifier { get; set; }
     
    }
}
