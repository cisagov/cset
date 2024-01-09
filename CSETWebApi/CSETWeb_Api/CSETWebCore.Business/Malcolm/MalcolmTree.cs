using CSETWebCore.Model.Malcolm;
using Lucene.Net.Util;
using NPOI.POIFS.Properties;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcolmTree
    {
        
        private HashSet<string> alreadySeenList = new HashSet<string>();

        public List<TempNode> RootNodes { get; set; }

        public MalcolmTree()
        {
            RootNodes = new List<TempNode>();
        }

        public void StartTheTreeWalk(Dictionary<string, TempNode> childrenDict)
        {   
            foreach (TempNode t in childrenDict.Values)
            {  
                TempNode root = new TempNode(t.Key);
                if (!alreadySeenList.Contains(root.Key))
                {   
                    WalkTree(null,root,t);
                    RootNodes.Add(root);
                }
            }

        }


        public void WalkTree(TempNode parent, TempNode treeNode, TempNode graph)
        {
            if (alreadySeenList.Contains(treeNode.Key))
            {
                return;
            }
            alreadySeenList.Add(treeNode.Key);
            
            foreach (var child in graph.Children)
            {
                if (parent != null)
                    parent.Children.Add(treeNode);
                WalkTree(treeNode, new TempNode(child.Key), child);
            }
        }
    }
}
