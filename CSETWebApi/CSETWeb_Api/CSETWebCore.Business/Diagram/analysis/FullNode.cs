//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.Analysis;

namespace CSETWebCore.Business
{
    public class FullNode
    {
        public NetworkComponent Source { get; set; }
        public NetworkComponent Target { get; set; }
        public NetworkLink Link { get; set; }
    }
}