//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;

namespace CSETWebCore.Api.Models
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
