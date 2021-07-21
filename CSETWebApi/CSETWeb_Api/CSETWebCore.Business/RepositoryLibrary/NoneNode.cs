using System;
using CSETWebCore.Api.Models;
using CSETWebCore.Enum;

namespace CSETWebCore.Business.RepositoryLibrary
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