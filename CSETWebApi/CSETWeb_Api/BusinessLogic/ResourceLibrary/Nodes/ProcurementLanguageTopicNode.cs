//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using CSETWebCore.DataLayer;

namespace ResourceLibrary.Nodes
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


