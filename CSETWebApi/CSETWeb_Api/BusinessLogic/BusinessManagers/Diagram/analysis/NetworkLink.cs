//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    internal class NetworkLink
    {
        public NetworkNode TargetComponent { get; internal set; }
        public NetworkNode SourceComponent { get; internal set; }
        public bool IsVisible { get; internal set; }
        public object Security { get; internal set; }
    }
}