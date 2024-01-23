using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSETWebCore.Model.Malcolm
{

    public class StatusTempNode { 
        public StatusTempNode() {
            NeedsProcessed = true;
        }
        public TempNode Node {  get; set; }
        public bool NeedsProcessed { get; set; }
    }


    public class TempNode
    {
        public HashSet<TempNode> Children {  get; set; }
        public string Key {  get; set; }
        public string Role { get; set; }
        
        private HashSet<string> alreadySeenList = new HashSet<string>();

        public TempNode(string key) {
            this.Key = key;
            this.Children = new HashSet<TempNode>();
        
        }
        
        public void AddChildGraphOnly(TempNode child)
        {
            if (child.Key == this.Key)
                return;            
            if (!ChildrenKeys.Contains(child.Key))
            {
                ChildrenKeys.Add(child.Key);
                Children.Add(child);
            }
            if (!child.ChildrenKeys.Contains(this.Key))
                child.AddChildGraphOnly(this);
        }

        public HashSet<string> ChildrenKeys = new HashSet<string>();
        
        public string PrintChildrenList()
        {
            StringBuilder sb = new StringBuilder();
            foreach(var tmpNode in Children)
            {   
                sb.Append(tmpNode.Key);
                sb.Append(",");
            }
            return sb.ToString();
        }

        public bool AlreadyWalked(TempNode treeNode, HashSet<string> previous)
        {
            if (previous.Contains(treeNode.Key)) return true;
            if(this.Key == treeNode.Key) return true;
            if (this.Children.Count == 0) return true;

            if (!alreadySeenList.Contains(treeNode.Key))
            {
                alreadySeenList.Add(treeNode.Key);
                return false;
            }
            return true;
            
        }
    }
}