//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using ResourceLibrary.Nodes;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
namespace CSET_Main.Data.ControlData
{
    public interface IResourceLibraryRepository
    {
       CatalogRecommendationsTopicNode GetCatalogRecommendationsNode(int id);
       ProcurementLanguageTopicNode GetProcurmentLanguageNode(int id);
       Dictionary<int, ResourceNode> ResourceModelDictionary { get; }
       ObservableCollection<ResourceNode> TopNodes { get; }
        List<SimpleNode> GetTreeNodes();
       string GetCatalogFlowText(int id);

       string GetProcurementFlowText(int id);
    }
}


