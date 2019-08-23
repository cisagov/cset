//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    internal class NetworkLayer
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