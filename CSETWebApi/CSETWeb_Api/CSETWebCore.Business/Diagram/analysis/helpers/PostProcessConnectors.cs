//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Diagram.analysis.helpers
{
    class PostProcessConnectors
    {
        public static Dictionary<String, NetworkComponent> RemoveConnectors(Dictionary<String, NetworkComponent> nodes)
        {
            PostProcessConnectors processor = new PostProcessConnectors(nodes);
            processor.SetIsMultiHomed();
            processor.ProcessConnectors();
            return processor.nodes;
        }

        private PostProcessConnectors(Dictionary<String, NetworkComponent> nodes)
        {
            this.nodes = nodes;
        }

        private Dictionary<string, NetworkComponent> nodes { get; set; }

        private void SetIsMultiHomed()
        {
            foreach (NetworkComponent nc in nodes.Values)
            {
                nc.isMultipleConnections = (nc.Connections.Count > 1);
            }
        }


        /// <summary>
        /// Connectors are actually a visualization thing only 
        /// for each connector find all connections and replace 
        /// with a connection as if this connector did not exist
        /// </summary>
        private void ProcessConnectors()
        {
            //extract the leafnode spanning tree from each connector
            //then generate all the connections for that connector bus
            //attaching both sides of the connection
            //so once I have seen a connector I never need to process it again
            CombinationsGenerator combinations = new CombinationsGenerator();
            List<NetworkComponent> connectors = this.nodes.Values.Where(x => x.IsLinkConnector).ToList();
            HashSet<NetworkComponent> ProcessedAlreadyConnections = new HashSet<NetworkComponent>();

            //create all other connections
            foreach (NetworkComponent nc in connectors)
            {
                if (!ProcessedAlreadyConnections.Contains(nc))
                {
                    ExtractLeafSpanningTree treeConnections = new ExtractLeafSpanningTree(nc);
                    foreach (NetworkComponent already in treeConnections.ProcessedAlreadyConnections)
                    {
                        ProcessedAlreadyConnections.Add(already);
                    }
                    List<NetworkComponent> connections = treeConnections.FinalList;
                    foreach (List<NetworkComponent> node in combinations.GetAllCombos(connections).Where(x => x.Count == 2).ToList())
                    {
                        node[0].Connections.Add(node[1]);
                        node[1].Connections.Add(node[0]);
                    }
                }
                //at this point all connections have been created
                //and we can safely remove the connectors
                this.nodes.Remove(nc.ID);                                
                nc.Connections.RemoveAll(x => x.IsLinkConnector);                    
                
            }
        }
    }
}
