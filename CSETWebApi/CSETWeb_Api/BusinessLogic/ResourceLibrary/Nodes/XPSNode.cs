//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using DataLayerCore.Model;
using System;
using System.IO;


namespace ResourceLibrary.Nodes
{
    public class XPSNode : ResourceNode
    {
        public XPSNode(String xpsDirectory, GEN_FILE doc)
            : base(doc)
        {
            Type = ResourceNodeType.XPSDoc;
            string fileName = Path.GetFileNameWithoutExtension(doc.File_Name);
            PathDoc = xpsDirectory + fileName + ".xps";
            FileName = fileName;
        }
    }
}


