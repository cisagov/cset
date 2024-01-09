using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using System;
using System.Collections.Generic;
using System.Text;

namespace CSETWebCore.Model.Malcolm
{
    public class TempNode
    {
        public List<TempNode> Children {  get; set; }
        public string Key {  get; set; }
        public TempNode(string key) {
            this.Key = key;
            this.Children = new List<TempNode>();
        }
        
        public void AddChildGraphOnly(TempNode child)
        {
            if (child.Key == this.Key)
                return;
            if (!ChildrenKeys.Contains(child.Key))
            {
                ChildrenKeys.Add(child.Key);
                Children.Add(child);                
                child.AddChildGraphOnly(this);
                
            }
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
    }
}