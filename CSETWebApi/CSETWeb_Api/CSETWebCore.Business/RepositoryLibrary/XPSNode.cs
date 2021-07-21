using System;
using System.IO;
using CSETWebCore.Api.Models;
using CSETWebCore.DataLayer;
using CSETWebCore.Enum;

namespace CSETWebCore.Business.RepositoryLibrary
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