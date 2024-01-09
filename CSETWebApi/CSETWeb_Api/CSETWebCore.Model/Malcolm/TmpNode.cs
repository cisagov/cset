using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using System;
using System.Collections.Generic;
using System.Text;

namespace CSETWebCore.Model.Malcolm
{
    public class TmpNode
    {
        public List<TmpNode> Children {  get; set; }
        public string Key {  get; set; }
        public TmpNode(string key) {
            this.Key = key;
            this.Children = new List<TmpNode>();
        }

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