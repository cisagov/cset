using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using CSETWebCore.Api.Interfaces;
using CSETWebCore.Api.Models;
using CSETWebCore.Enum;
using CSETWebCore.Interfaces.ResourceLibrary;
using CSETWebCore.Model.ResourceLibrary;
using Lucene.Net.Analysis;
using Lucene.Net.Analysis.Standard;
using Lucene.Net.Index;
using Lucene.Net.QueryParsers;
using Lucene.Net.Search;
using Lucene.Net.Store;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.RepositoryLibrary
{
    public class SearchDocs
    {
        private MultiFieldQueryParser multiParser;
        private Searcher searcher;
        private IResourceLibraryRepository resourceLibrary;

        public SearchDocs(ICSETGlobalProperties globalProperties, IResourceLibraryRepository resourceLibrary)
        {
            try
            {
                string luceneDirectory = Path.Combine(globalProperties.Application_Path, "LuceneIndex");

                this.resourceLibrary = resourceLibrary;
                Lucene.Net.Store.Directory fsDir = FSDirectory.Open(new DirectoryInfo(luceneDirectory));

                IndexReader reader = IndexReader.Open(fsDir, true);

                searcher = new IndexSearcher(reader);
                Analyzer analyzer = new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_30);

                multiParser = new MultiFieldQueryParser(Lucene.Net.Util.Version.LUCENE_30, FieldNames.Array_Field_Names, analyzer);
                QueryParser parser = new QueryParser(Lucene.Net.Util.Version.LUCENE_30, "contents", analyzer);
            }
            catch (Exception ex)
            {
                //CSETLogger.Fatal("Failed to load the search doc constructor.", ex);
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

                TermsFilter filter = new TermsFilter();
                Boolean isFilter = true;
                if (isProcurement)
                {
                    filter.AddTerm(new Term(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Procurement_Language.ToString()));
                }
                if (isCatalog)
                {
                    filter.AddTerm(new Term(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Catalog_Recommendation.ToString()));
                }
                if (isResourceDocs)
                {
                    filter.AddTerm(new Term(FieldNames.RESOURCE_TYPE, ResourceTypeEnum.Resource_Doc.ToString()));
                }

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
                        listResourceDocuments.Add(resDoc);
                }
                return listResourceDocuments;
            }
            catch (Exception ex)
            {
                //May get exceptions if put symbols and other wierd things in search.  So then just return an empty list in that case.
                //CSETLogger.Fatal("An exception occurred in finding items in search.", ex);
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
                    resDoc = resourceLibrary.GetProcurmentLanguageNode(docId);
                else if (resourceTypeEnum == ResourceTypeEnum.Catalog_Recommendation)
                    resDoc = resourceLibrary.GetCatalogRecommendationsNode(docId);
                return resDoc;
            }
            catch (Exception ex)
            {
                return null;
            }

        }
    }
}