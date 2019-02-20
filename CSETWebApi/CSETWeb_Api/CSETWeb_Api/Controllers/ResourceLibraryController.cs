//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Common;
using CSET_Main.Data.ControlData;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using DataLayerCore.Model;
using Lucene.Net.Analysis;
using Lucene.Net.Analysis.Standard;
using Lucene.Net.Documents;
using Lucene.Net.Index;
using Lucene.Net.QueryParsers;
using Lucene.Net.Search;
using Lucene.Net.Store;
using ResourceLibrary.Nodes;
using ResourceLibrary.Search;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    public class ResourceLibraryController : ApiController
    {
        /// <summary>
        /// Returns the details under a given question
        /// </summary>
        /// <param name="searchRequest"></param>
        /// <returns></returns>        
        [HttpPost]
        [Route("api/ResourceLibrary")]
        public List<ResourceNode> GetDetails([FromBody] SearchRequest searchRequest)
        {
            if (String.IsNullOrWhiteSpace(searchRequest.term))
                return new List<ResourceNode>();

            Lucene.Net.Store.Directory fsDir = FSDirectory.Open(new DirectoryInfo(Path.Combine(CSETGlobalProperties.Static_Application_Path, "LuceneIndex")));

            IndexReader reader = IndexReader.Open(fsDir, true);
            Searcher searcher = new IndexSearcher(reader);
            Analyzer analyzer = new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29);
            CSETGlobalProperties props = new CSETGlobalProperties();
            using (CSET_Context context = new CSET_Context()) {
                SearchDocs search = new SearchDocs(props, new ResourceLibraryRepository(context, props));
                return search.Search(searchRequest);
            }
        }

        [HttpGet]
        [Route("api/ResourceLibrary/tree")]
        public List<SimpleNode> GetTree()
        {
            using (CSET_Context context = new CSET_Context()) {
                IResourceLibraryRepository resource = new ResourceLibraryRepository(context,new CSETGlobalProperties());
                return resource.GetTreeNodes();
            }
        }

        [HttpGet]
        [Route("api/ResourceLibrary/doc")]
        public string GetFlowDoc([FromUri] string type, [FromUri] int id)
        {
            // pull the flowdoc from the database
            BusinessManagers.FlowDocManager fdm = new BusinessManagers.FlowDocManager();
            string html = fdm.GetFlowDoc(type, id);

            return html;            
        }
    }
}


