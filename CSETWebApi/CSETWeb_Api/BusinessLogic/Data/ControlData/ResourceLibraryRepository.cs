//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using ResourceLibrary.Nodes;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using DataLayerCore.Model;
using Nelibur.ObjectMapper;
using BusinessLogic.Helpers;

namespace CSET_Main.Data.ControlData
{
    public class ResourceLibraryRepository : IResourceLibraryRepository
    {
       

        public ObservableCollection<ResourceNode> TopNodes { get; private set; }
        public Dictionary<int, ResourceNode> ResourceModelDictionary{get; private set;}

        private CSET_Main.Common.ICSETGlobalProperties globalProperties;
        private CsetwebContext controlContextHolder;
        private string pdfDirectory;
        private string xpsDirectory;

        public ResourceLibraryRepository(CsetwebContext controlContextHolder, CSET_Main.Common.ICSETGlobalProperties globalProperties)
        {           
            this.controlContextHolder = controlContextHolder;
            this.globalProperties = globalProperties;
            this.pdfDirectory = Path.Combine(Constants.DOCUMENT_PATH);
            this.xpsDirectory = Path.Combine(Constants.XPS_DOCUMENT_PATH);
            CreateResourceLibraryData();
            
        }

        public List<SimpleNode> GetTreeNodes() {
            return getNodes(this.TopNodes.ToList());
        }

        private List<SimpleNode> getNodes(List<ResourceNode> nodes)
        {

            List<SimpleNode> rlist = new List<SimpleNode>();
            //walk through the tree and extract 
            //a copy with only the fields we want. 
            SimpleNode s = null;
            foreach(ResourceNode r in nodes)
            {
                List<SimpleNode> schildren = getNodes(r.Nodes.ToList());
                s = new SimpleNode()
                {
                    label = r.TreeTextNode,
                    value = r.FileName,
                    children = schildren,
                    HeadingText = r.HeadingText,
                    HeadingTitle = r.HeadingTitle,
                    DatePublished = r.DatePublished
                };

                if (s.value == null)
                {
                    s.DocId = r.PathDoc;
                }

                rlist.Add(s);
            }
            return rlist;

        }


        public void CreateResourceLibraryData()
        {
            try
            {
                TopNodes = new ObservableCollection<ResourceNode>();
                ResourceModelDictionary = new Dictionary<int, ResourceNode>();
               

                Dictionary<int, ResourceNode> ResourceNodeDict = new Dictionary<int, ResourceNode>();             
                var items = controlContextHolder.REF_LIBRARY_PATH.Select(x => new { REF_LIB = x, GEN_FILE_Items = x.GEN_FILE }).ToList();         
                foreach (var obj in items)
                {
                    ResourceNode node = new NoneNode();
                    node.ID = Convert.ToInt32(obj.REF_LIB.Lib_Path_Id);
                    if (obj.REF_LIB.Parent_Path_Id.HasValue)
                        node.ParentID = Convert.ToInt32(obj.REF_LIB.Parent_Path_Id);
                    else
                        node.ParentID = -1;

                    node.TreeTextNode = obj.REF_LIB.Path_Name;
                    node.Type = ResourceNodeType.None;
                    node.Nodes = new ObservableCollection<ResourceNode>();
                    List<ResourceNode> listItems = new List<ResourceNode>();
                    foreach (GEN_FILE doc in obj.GEN_FILE_Items)
                    {
                        if (ResourceModelDictionary.ContainsKey(doc.Gen_File_Id))  //Check if node is already created
                        {
                            ResourceNode getNode = ResourceModelDictionary[doc.Gen_File_Id];
                            listItems.Add(getNode);
                        }
                        else if (doc.File_Type_Id == 31)//pdf
                        {
                            ResourceNode pdfNode = new PDFNode(pdfDirectory, doc);
                            ResourceModelDictionary.Add(pdfNode.ID, pdfNode);
                            listItems.Add(pdfNode);
                        }
                        else if (doc.File_Type_Id == 41)//docx
                        {
                            ResourceNode docxNode = new XPSNode(xpsDirectory, doc);
                            ResourceModelDictionary.Add(docxNode.ID, docxNode);
                            listItems.Add(docxNode);
                        }
                        else
                        {
                            Debug.Assert(false, "Invalid document type: " + doc.FILE_TYPE.File_Type1);
                        }
                    }
                    foreach (ResourceNode rn in listItems.OrderBy(x => x.TreeTextNode)) {
                        node.Nodes.Add(rn);
                    }
                    ResourceNodeDict.Add(node.ID, node);

                }
           
                foreach (ResourceNode libDoc in ResourceNodeDict.Values)
                {
                    if (libDoc.ParentID == -1)
                    {
                        TopNodes.Add(libDoc);
                    }
                    else
                    {
                        ResourceNode lib = ResourceNodeDict[libDoc.ParentID];
                        lib.Nodes.Add(libDoc);
                    }
                }


                ResourceNode procTopicModel = new NoneNode("Cyber Security Procurement Language");
                TopNodes.Add(procTopicModel);

                Dictionary<int,List<PROCUREMENTLANGUAGEDATA>> dictionaryProcurementLanguageData = new Dictionary<int,List<PROCUREMENTLANGUAGEDATA>>();

                foreach (PROCUREMENT_LANGUAGE_DATA data in controlContextHolder.PROCUREMENT_LANGUAGE_DATA.ToList())
                {
                    List<PROCUREMENTLANGUAGEDATA> list;
                    if (!dictionaryProcurementLanguageData.TryGetValue(data.Parent_Heading_Id.Value, out list))
                    {
                        list = new List<PROCUREMENTLANGUAGEDATA>();
                        dictionaryProcurementLanguageData[data.Parent_Heading_Id.Value] = list;
                    }
                  
                    list.Add(TinyMapper.Map<PROCUREMENTLANGUAGEDATA>(data));
                }
              
                foreach (PROCUREMENT_LANGUAGE_HEADINGS procHeading in controlContextHolder.PROCUREMENT_LANGUAGE_HEADINGS.OrderBy(h => h.Heading_Num).ToList())
                {
                    ResourceNode procHeadingModel = new NoneNode(procHeading.Heading_Name);
                    procTopicModel.Nodes.Add(procHeadingModel);
                    List<PROCUREMENTLANGUAGEDATA> listItems = dictionaryProcurementLanguageData[procHeading.Id];
                    foreach (PROCUREMENTLANGUAGEDATA data in listItems.OrderBy(d => d.Section_Number))
                    {
                        ResourceNode procModel = new ProcurementLanguageTopicNode(data);
                        procHeadingModel.Nodes.Add(procModel);
                    }
                }


                ResourceNode recCatTopicModel = new NoneNode("Catalog of Recommendations");
                TopNodes.Add(recCatTopicModel);

                Dictionary<int, List<CATALOGRECOMMENDATIONSDATA>> dictionaryCatalogRecommendations = new Dictionary<int, List<CATALOGRECOMMENDATIONSDATA>>();

                foreach (CATALOG_RECOMMENDATIONS_DATA data in controlContextHolder.CATALOG_RECOMMENDATIONS_DATA.ToList())
                {
                    List<CATALOGRECOMMENDATIONSDATA> list;
                    if (!dictionaryCatalogRecommendations.TryGetValue(data.Parent_Heading_Id.Value, out list))
                    {
                        list = new List<CATALOGRECOMMENDATIONSDATA>();
                        dictionaryCatalogRecommendations[data.Parent_Heading_Id.Value] = list;
                    }

                    list.Add(TinyMapper.Map<CATALOGRECOMMENDATIONSDATA>(data));
                }

                foreach (CATALOG_RECOMMENDATIONS_HEADINGS procHeading in controlContextHolder.CATALOG_RECOMMENDATIONS_HEADINGS.OrderBy(h => h.Heading_Num).ToList())
                {
                    ResourceNode procHeadingModel = new NoneNode(procHeading.Heading_Name);
                    recCatTopicModel.Nodes.Add(procHeadingModel);

                    List<CATALOGRECOMMENDATIONSDATA> listItems = dictionaryCatalogRecommendations[procHeading.Id];
                    foreach (CATALOGRECOMMENDATIONSDATA data in listItems.OrderBy(d => d.Section_Short_Number))
                    {
                        ResourceNode procModel = new CatalogRecommendationsTopicNode(data);
                        procHeadingModel.Nodes.Add(procModel);
                    }
                }
               
            }
            catch (Exception ex)
            {
                //CSET_Main.Common.CSETLogger.Fatal("An exception occurred in loading resource library.", ex);
            }
        }

        private PROCUREMENTLANGUAGEDATA GetProcurmentLanguage(int id)
        {
            return TinyMapper.Map<PROCUREMENTLANGUAGEDATA>(controlContextHolder.PROCUREMENT_LANGUAGE_DATA.First(data => data.Procurement_Id == id));
        }

        public ProcurementLanguageTopicNode GetProcurmentLanguageNode(int id)
        {
            return new ProcurementLanguageTopicNode(GetProcurmentLanguage(id));
        }

        private CATALOGRECOMMENDATIONSDATA GetCatalogRecommendations(int id)
        {
            return TinyMapper.Map<CATALOGRECOMMENDATIONSDATA>(controlContextHolder.CATALOG_RECOMMENDATIONS_DATA.First(data => data.Data_Id == id));
        }

        public CatalogRecommendationsTopicNode GetCatalogRecommendationsNode(int id)
        {
            return new CatalogRecommendationsTopicNode(GetCatalogRecommendations(id));
        }


        public string GetCatalogFlowText(int id)
        {
            return GetCatalogRecommendations(id).Flow_Document;
        }

        public string GetProcurementFlowText(int id)
        {
            return GetProcurmentLanguage(id).Flow_Document;
        }
    }

    public class SimpleNode
    {
        public List<SimpleNode> children { get; set; }
        public string label { get; set; }
        public string value { get; set; }
        public string DocId { get; set; }
        public string DatePublished { get; set; }
        public string HeadingTitle { get; set; }
        public string HeadingText { get; set; }
    }
}


