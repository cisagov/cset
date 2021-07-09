//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using DataLayerCore.Model;

namespace ResourceLibrary.Nodes
{
    public class XLSXNode : ResourceNode
    {
        public XLSXNode(string directory, GEN_FILE doc)
            : base(doc)
        {
            Type = ResourceNodeType.XLSXDoc;
            PathDoc = directory + doc.File_Name;
            FileName = doc.File_Name;
        }

    }
}


