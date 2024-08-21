//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using CSETWebCore.Api.Interfaces;
using CSETWebCore.Api.Models;
using CSETWebCore.Enum;
using CSETWebCore.Interfaces.ResourceLibrary;
using CSETWebCore.Model.ResourceLibrary;
using Lucene.Net.Analysis;
using Lucene.Net.Analysis.Standard;
using Lucene.Net.Index;
using Lucene.Net.Queries;
using Lucene.Net.QueryParsers.Classic;
using Lucene.Net.Search;
using Lucene.Net.Store;

namespace CSETWebCore.Business.RepositoryLibrary
{
    public class SearchDocs
    {
        private MultiFieldQueryParser multiParser;
        private IndexSearcher searcher;
        private IResourceLibraryRepository resourceLibrary;

        public SearchDocs(ICSETGlobalProperties globalProperties, IResourceLibraryRepository resourceLibrary)
        {
            try
            {
                string luceneDirectory = Path.Combine(globalProperties.Application_Path, "LuceneIndex");

                this.resourceLibrary = resourceLibrary;
                Lucene.Net.Store.Directory fsDir = FSDirectory.Open(new DirectoryInfo(luceneDirectory));

                IndexReader reader = DirectoryReader.Open(fsDir);

                searcher = new IndexSearcher(reader);
                Term term = new Term("title", "lucene");
                Analyzer analyzer = new StandardAnalyzer(Lucene.Net.Util.LuceneVersion.LUCENE_48);

                multiParser = new MultiFieldQueryParser(Lucene.Net.Util.LuceneVersion.LUCENE_48, FieldNames.Array_Field_Names, analyzer);
                QueryParser parser = new QueryParser(Lucene.Net.Util.LuceneVersion.LUCENE_48, "contents", analyzer);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                Debug.Assert(false, "Failed to load the search doc constructor.");
            }

        }

        public List<ResourceNode> Search(SearchRequest searchRequest)
        {
            return Search(searchRequest.term, searchRequest.isResourceDocs, searchRequest.isProcurement, searchRequest.isCatalog);
        }

        public List<ResourceNode> Search(string term, bool isResourceDocs, bool isProcurement, bool isCatalog)
        {
            try
            {
                if (String.IsNullOrWhiteSpace(term))
                    return new List<ResourceNode>();
                Query query = multiParser.Parse(term);

                TopDocs docs = null;

                List<Term> terms = new List<Term>();
                Boolean isFilter = true;
                if (isProcurement)
                {
                    terms.Add(new Term(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Procurement_Language.ToString()));
                }
                if (isCatalog)
                {
                    terms.Add(new Term(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Catalog_Recommendation.ToString()));
                }
                if (isResourceDocs)
                {
                    terms.Add(new Term(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Resource_Doc.ToString()));
                }

                TermsFilter filter = new TermsFilter(terms);
                if (isFilter)
                    docs = searcher.Search(query, filter, 20);
                else
                    docs = searcher.Search(query, 20);


                List<ResourceNode> listResourceDocuments = new List<ResourceNode>();

                foreach (ScoreDoc doc in docs.ScoreDocs)
                {
                    int lucDocId = doc.Doc;

                    Lucene.Net.Documents.Document lucDoc = searcher.Doc(lucDocId);
                    string sDocId = lucDoc.Get(FieldNames.DOC_ID);

                    int docId = 0;
                    if (sDocId != null)
                        docId = Int32.Parse(sDocId);
                    else
                    {
                        docId = -1;
                    }

                    string resourceType = lucDoc.Get(FieldNames.RESOURCE_TYPE);
                    ResourceTypeEnum resourceTypeEnum = (ResourceTypeEnum)System.Enum.Parse(typeof(ResourceTypeEnum), resourceType, true);
                    ResourceNode resDoc = GetDoc(docId, resourceTypeEnum);
                    if (resDoc != null)
                    {
                        resDoc.Score = doc.Score;
                        listResourceDocuments.Add(resDoc);
                    }
                }

                return listResourceDocuments.OrderBy(x => x.HeadingTitle).OrderByDescending(x => x.DatePublished).OrderByDescending(x => x.Score).ToList();
            }
            catch (Exception exc)
            {
                //May get exceptions if put symbols and other wierd things in search.  So then just return an empty list in that case.
                //CSETLogger.Fatal("An exception occurred in finding items in search.", ex);

                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return new List<ResourceNode>();
            }


        }

        private ResourceNode GetDoc(int docId, ResourceTypeEnum resourceTypeEnum)
        {
            ResourceNode resDoc = null;
            try
            {
                if (resourceTypeEnum == ResourceTypeEnum.Resource_Doc)
                    resDoc = resourceLibrary.ResourceModelDictionary[docId];
                else if (resourceTypeEnum == ResourceTypeEnum.Procurement_Language)
                    resDoc = resourceLibrary.GetProcurementLanguageNode(docId);
                else if (resourceTypeEnum == ResourceTypeEnum.Catalog_Recommendation)
                    resDoc = resourceLibrary.GetCatalogRecommendationsNode(docId);
                return resDoc;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return null;
            }

        }
    }
}