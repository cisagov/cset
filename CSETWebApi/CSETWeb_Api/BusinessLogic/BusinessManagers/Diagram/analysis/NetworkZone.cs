using CSETWeb_Api.BusinessManagers;
using System.Collections.Generic;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.Analysis
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
            "Control System"};
    }
}