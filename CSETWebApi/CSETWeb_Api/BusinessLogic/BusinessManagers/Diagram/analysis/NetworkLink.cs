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
        public NetworkComponent TargetComponent { get; internal set; }
        public NetworkComponent SourceComponent { get; internal set; }
        public bool IsVisible { get; internal set; }
        public object Security { get; internal set; }
    }
}