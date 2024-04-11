using CSETWebCore.Model.Malcolm;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcolmTree
    {
        
        private HashSet<string> alreadySeenList = new HashSet<string>();

        

        public MalcolmTree()
        {
            
        }

        private Dictionary<string, TempNode> listOfAll = new Dictionary<string, TempNode>();

        public List<TempNode> StartTheTreeWalk(Dictionary<string, TempNode> childrenDict) 
        { 
            List<TempNode> RootNodes = new List<TempNode>();
            foreach (TempNode t in childrenDict.Values)
            {
                if (!alreadySeenList.Contains(t.Key))
                {
                    TempNode root = new TempNode(t.Key);
                    root.Role = t.Role;
                    listOfAll.Add(root.Key, root);
                    RootNodes.Add(root);
                    HashSet<string> seen = new HashSet<string>() { root.Key };
                    WalkTree(root,t,seen);                    
                }
                    
            }
            return RootNodes;
        }

        private void WalkTree(TempNode parent, TempNode graphNode, HashSet<string> alreadySeen)
        {   
            //trying to do breadth first
            //add all the children to the parent
            //then recurse down the children
            HashSet<string> visited = new HashSet<string>(alreadySeen);
            visited.Add(parent.Key);
            visited.Add(graphNode.Key);
            //Trace.WriteLine("W: "+parent.Key+ "G: "+graphNode.Key);

            Dictionary<TempNode, bool> children = new Dictionary<TempNode, bool>();
            foreach (var c in graphNode.Children)
            {

                TempNode cnode;
                if (listOfAll.TryGetValue(c.Key, out cnode))
                {
                    if (graphNode.AlreadyWalked(cnode,visited))
                    {
                        children.TryAdd(c, false);
                    }
                    else
                    {
                        visited.Add(cnode.Key);
                        AddNode(parent, cnode);
                        children.TryAdd(c, true);
                    }
                    
                }
                else
                {
                    var newT = new TempNode(c.Key);
                    newT.Role = c.Role;
                    if (graphNode.AlreadyWalked(newT, visited))
                    {
                        children.TryAdd(c, false);
                    }
                    else
                    {
                        visited.Add(newT.Key);
                        listOfAll.TryAdd(newT.Key, newT);
                        AddNode(parent, newT);
                        children.TryAdd(c, true);
                    }
                }
            }
            List<TempNode> childrenToWalk = children.Where(x => x.Value).Select(x=> x.Key).ToList();
            foreach (var c in childrenToWalk)
            {
                TempNode cnode;
                if (listOfAll.TryGetValue(c.Key, out cnode))
                {
                    WalkTree(cnode,  c,visited);
                    //Trace.WriteLine("rf:" + parent.Key + "-" + graphNode.Key);
                }
                else
                {
                    var newT= new TempNode(c.Key);
                    newT.Role = c.Role;
                    listOfAll.Add(c.Key, newT);
                    WalkTree(newT, c, visited);
                    //Trace.WriteLine("rn:" + parent.Key + "-" + graphNode.Key);
                }
            }
            
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="parent"></param>
        /// <param name="treeNode"></param>
        /// <param name="graph"></param>
        /// <returns>true if needs processed false if not</returns>
        private bool AddNode(TempNode parent, TempNode treeNode)
        {   
            if(alreadySeenList.Contains(treeNode.Key) && alreadySeenList.Contains(parent.Key))
            {
                return true;
            }
            //Trace.WriteLine("Adding: " + parent.Key+" ->" +treeNode.Key);
            parent.Children.Add(treeNode);
            alreadySeenList.Add(treeNode.Key);
            alreadySeenList.Add(parent.Key);
            return true;
            

        }
    }
}
