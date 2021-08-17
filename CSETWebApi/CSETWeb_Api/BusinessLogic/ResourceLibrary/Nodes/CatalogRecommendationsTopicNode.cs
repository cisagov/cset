//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSET_Main.Data;
using DataLayerCore.Model;
using Nelibur.ObjectMapper;

namespace ResourceLibrary.Nodes
{
    public class CatalogRecommendationsTopicNode : TopicNode
    {
        static CatalogRecommendationsTopicNode(){
            TinyMapper.Bind<CATALOG_RECOMMENDATIONS_DATA, CATALOGRECOMMENDATIONSDATA>();
            TinyMapper.Bind<CATALOGRECOMMENDATIONSDATA, CATALOGRECOMMENDATIONSDATA>();
        }
        public CATALOGRECOMMENDATIONSDATA Data { get; set; }

        public CatalogRecommendationsTopicNode(CATALOGRECOMMENDATIONSDATA recommTopicData)
            : base(recommTopicData)
        {   
            this.Data = TinyMapper.Map<CATALOGRECOMMENDATIONSDATA>(recommTopicData);

            this.HeadingTitle = this.Data.Topic_Name;
            this.HeadingText = this.Data.Heading;
            this.PathDoc = "catalog:" + this.Data.Data_Id;
        }
    }

    public class PROCUREMENTLANGUAGEDATA
    {
        public int Procurement_Id { get; set; }
        public Nullable<int> Parent_Heading_Id { get; set; }
        public string Section_Number { get; set; }
        public string Topic_Name { get; set; }
        public string Heading { get; set; }
        public string Basis { get; set; }
        public string Language_Guidance { get; set; }
        public string Procurement_Language { get; set; }
        public string Fatmeasures { get; set; }
        public string Satmeasures { get; set; }
        public string Maintenance_Guidance { get; set; }
        public string References_Doc { get; set; }
        public string Flow_Document { get; set; }
    }

    public class CATALOGRECOMMENDATIONSDATA
    {
        public int Data_Id { get; set; }
        public Nullable<int> Req_Oracle_Id { get; set; }
        public Nullable<int> Parent_Heading_Id { get; set; }
        public string Heading { get; set; }
        public string Heading_Html { get; set; }
        public string Section_Long_Number { get; set; }
        public string Section_Short_Number { get; set; }
        public string Topic_Name { get; set; }
        public string Section_Short_Name { get; set; }
        public string Requirement_Text { get; set; }
        public string Supplemental_Guidance { get; set; }
        public string Supplemental_Guidance_Html { get; set; }
        public string Requirement { get; set; }
        public string Requirement_Html { get; set; }
        public string Enhancement { get; set; }
        public string Enhancement_Html { get; set; }
        public string Flow_Document { get; set; }

    }
}


