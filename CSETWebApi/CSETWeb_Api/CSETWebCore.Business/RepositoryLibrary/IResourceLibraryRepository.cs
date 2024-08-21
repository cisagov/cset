//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Collections.ObjectModel;
using CSETWebCore.Api.Models;
using CSETWebCore.Business.RepositoryLibrary;
using CSETWebCore.Model.ResourceLibrary;

namespace CSETWebCore.Interfaces.ResourceLibrary
{
    public interface IResourceLibraryRepository
    {
        CatalogRecommendationsTopicNode GetCatalogRecommendationsNode(int id);
        ProcurementLanguageTopicNode GetProcurementLanguageNode(int id);
        Dictionary<int, ResourceNode> ResourceModelDictionary { get; }
        ObservableCollection<ResourceNode> TopNodes { get; }
        List<SimpleNode> GetTreeNodes();
        string GetCatalogFlowText(int id);

        string GetProcurementFlowText(int id);
    }
}