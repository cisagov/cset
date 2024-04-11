//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business;
using System.Collections.Generic;

namespace CSETWebCore.Business.Diagram.Analysis
{
    public class NetworkZone : NetworkNode
    {
        public string ZoneType { get; set; }
        public string SAL { get; internal set; }
        public List<NetworkComponent> ContainingComponents { get; set; }
        public NetworkZone()
        {
            ContainingComponents = new List<NetworkComponent>();
        }

        private string[] zoneTypes = new string[] {
            "Control DMZ",
            "Corporate",
            "Other",
            "Safety",
            "External DMZ",
            "Plant System",
            "Control System",
            "Classified",
            "None"};
    }
}