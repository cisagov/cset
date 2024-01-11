using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Malcolm;
using CSETWebCore.Model.Malcolm;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcolmBusiness : IMalcolmBusiness
    {
        private CSETContext _context;


        private Dictionary<string, TempNode> networkOfNodes = new Dictionary<string, TempNode>();



        public MalcolmBusiness(CSETContext context)
        {
            _context = context;
        }

        public List<MalcolmData> GetMalcolmJsonData(List<MalcolmData> datalist)
        {   
            foreach (MalcolmData malcolmData in datalist)
            {
                if (malcolmData != null)
                {
                    foreach (var bucket in malcolmData.Values.Buckets)
                    {
                        //if (!networkOfNodes.ContainsKey(bucket.Key))
                        //{
                            var buckets = new List<Buckets>() { bucket };
                            BuildNetwork(null, buckets);
                        //}
                    }
                    malcolmData.Graphs = networkOfNodes;
                    networkOfNodes = new Dictionary<string, TempNode>();           
                }
            }
            datalist = GetTreesFromMalcolmData(datalist);
            return datalist;

        }
        public List<MalcolmData> GetTreesFromMalcolmData(List<MalcolmData> datalist)
        {
            var malcolmDataList = new List<MalcolmData>();            
            foreach (MalcolmData malcolmData in datalist)
            {
                if (malcolmData != null)
                {   
                    MalcolmTree trees = new MalcolmTree();
                    malcolmData.Trees  =trees.StartTheTreeWalk(malcolmData.Graphs);
                    malcolmDataList.Add(malcolmData);
                }
            }
            return malcolmDataList;

        }

        private void BuildNetwork(TempNode parent, List<Buckets> buckets)
        {
            foreach (var bucket in buckets)
            {
                TempNode tnode;
                if (String.IsNullOrEmpty(bucket.Key))
                {
                    continue;
                }
                if (networkOfNodes.TryGetValue(bucket.Key, out tnode))
                {
                    if (parent != null)
                        parent.AddChildGraphOnly(tnode);                    
                }
                else
                {
                    tnode = new TempNode(bucket.Key);
                    networkOfNodes.TryAdd(bucket.Key, tnode);
                    if (parent != null)
                        parent.AddChildGraphOnly(tnode);
                }
                if (bucket.Values != null)
                {
                    BuildNetwork(tnode, bucket.Values.Buckets);
                }
            }
        }
    }
}
