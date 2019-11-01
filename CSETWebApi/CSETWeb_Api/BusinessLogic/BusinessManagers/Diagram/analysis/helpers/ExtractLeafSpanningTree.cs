using CSETWeb_Api.BusinessManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.helpers
{
    class ExtractLeafSpanningTree
    {

        public HashSet<NetworkComponent> ProcessedAlreadyConnections = new HashSet<NetworkComponent>();
        private HashSet<NetworkComponent> finalList = new HashSet<NetworkComponent>();
        public List<NetworkComponent> FinalList
        {
            get
            {
                return finalList.ToList();
            }
        }

        private void AllConnections(List<NetworkComponent> connectors)
        {
            
            foreach (var connector in connectors)
            {
                if (connector.IsLinkConnector)
                {
                    if (!ProcessedAlreadyConnections.Contains(connector))
                    {
                        ProcessedAlreadyConnections.Add(connector);
                        AllConnections(connector.Connections);
                    }
                }
                else
                {
                    finalList.Add(connector);
                }

            }
        }

        public ExtractLeafSpanningTree(NetworkComponent nc)
        {   
            AllConnections(nc.Connections);
            ProcessedAlreadyConnections.Add(nc);
        }
    }
}
