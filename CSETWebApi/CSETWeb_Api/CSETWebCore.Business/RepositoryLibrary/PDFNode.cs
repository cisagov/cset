//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Api.Models;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;

namespace CSETWebCore.Business.RepositoryLibrary
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