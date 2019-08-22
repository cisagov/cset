using System;
namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    public interface INetworkAnalysisMessage
    {
        string Message { get; set; }
        int MessageIdentifier { get; set; }
    }
}
