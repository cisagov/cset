//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Business.Diagram.Analysis
{
    public class NetworkLayer:NetworkNode
    {
        public string ID { get; set; }
        public string LayerName { get; set; }
        public bool Visible { get; set; }

        public NetworkLayer()
        {
            Visible = true;
        }
    }
}