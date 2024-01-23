//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Business.Diagram.Analysis
{
    public class NetworkLayer : NetworkNode
    {
        public new string ID { get; set; }
        public string LayerName { get; set; }
        public bool Visible { get; set; }

        public NetworkLayer()
        {
            Visible = true;
        }
    }
}