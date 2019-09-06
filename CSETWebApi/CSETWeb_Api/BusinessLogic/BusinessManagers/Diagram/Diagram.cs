using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.Analysis;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram
{
    public class Diagram
    {
        public Dictionary<Guid, NetworkComponent> NetworkComponents { get; set; }
        
        public Dictionary<string, NetworkLayer> Layers { get; private set; }
        public Dictionary<string, NetworkZone> Zones { get; private set; }

        public Diagram()
        {
            NetworkComponents = new Dictionary<Guid, NetworkComponent>();            
            Layers = new Dictionary<string, NetworkLayer>();
            Zones = new Dictionary<string, NetworkZone>();

        }


    }
}
