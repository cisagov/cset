//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSET_Main.Data;


namespace ResourceLibrary.Nodes
{
    public class NoneNode : ResourceNode
    {
        public NoneNode(String treeTextNode)
            : base()
        {
            TreeTextNode = treeTextNode;
            Type = ResourceNodeType.None;
        }
        public NoneNode()
        {
        }

    }

}


