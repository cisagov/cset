//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Business.RepositoryLibrary
{
    public class ProcurementLanguageTopicNode : TopicNode
    {
        public PROCUREMENTLANGUAGEDATA Data { get; set; }

        public ProcurementLanguageTopicNode(PROCUREMENTLANGUAGEDATA data)
            : base(data)
        {
            this.Data = data;

            this.HeadingTitle = data.Topic_Name;
            this.HeadingText = data.Heading;
            this.PathDoc = "procurement:" + data.Procurement_Id;
        }
    }
}