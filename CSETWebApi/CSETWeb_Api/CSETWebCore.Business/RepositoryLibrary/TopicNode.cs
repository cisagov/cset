//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Api.Models;
using CSETWebCore.Enum;

namespace CSETWebCore.Business.RepositoryLibrary
{
    public class TopicNode : ResourceNode
    {
        protected TopicNode(PROCUREMENTLANGUAGEDATA procTopicData)
        {
            TreeTextNode = procTopicData.Topic_Name;
            Type = ResourceNodeType.ProcurementTopic;
            ID = procTopicData.Procurement_Id;
        }

        protected TopicNode(CATALOGRECOMMENDATIONSDATA recommTopicData)
        {
            TreeTextNode = recommTopicData.Topic_Name;
            Type = ResourceNodeType.RecCatalogTopic;
            ID = recommTopicData.Data_Id;
        }
    }
}