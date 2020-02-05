//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using DataLayerCore.Model;

namespace ResourceLibrary.Nodes
{
    public class PDFNode : ResourceNode
    {
        public PDFNode(string pdfDirectory, GEN_FILE doc)
            : base(doc)
        {
            Type = ResourceNodeType.PDFDoc;
            PathDoc = pdfDirectory + doc.File_Name;
            FileName = doc.File_Name;
        }

    }
}


