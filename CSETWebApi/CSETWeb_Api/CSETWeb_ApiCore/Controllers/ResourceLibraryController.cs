using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using CSETWebCore.Api.Models;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.RepositoryLibrary;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.ResourceLibrary;
using CSETWebCore.Model.ResourceLibrary;
using Lucene.Net.Analysis;
using Lucene.Net.Analysis.Standard;
using Lucene.Net.Index;
using Lucene.Net.Search;
using Lucene.Net.Store;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ResourceLibraryController : ControllerBase
    {
        private CSETContext _context;
        private readonly IHtmlFromXamlConverter _html;
        private readonly IFlowDocManager _flow;

        public ResourceLibraryController(CSETContext context, IHtmlFromXamlConverter html, IFlowDocManager flow)
        {
            _context = context;
            _html = html;
            _flow = flow;
        }

        /// <summary>
        /// Returns the details under a given question
        /// </summary>
        /// <param name="searchRequest"></param>
        /// <returns></returns>        
        [HttpPost]
        [Route("api/ResourceLibrary")]
        public IActionResult GetDetails([FromBody] SearchRequest searchRequest)
        {
            if (String.IsNullOrWhiteSpace(searchRequest.term))
                return Ok(new List<ResourceNode>());

            Lucene.Net.Store.Directory fsDir = FSDirectory.Open(new DirectoryInfo(Path.Combine(CSETGlobalProperties.Static_Application_Path, "LuceneIndex")));

            IndexReader reader = IndexReader.Open(fsDir, true);
            Searcher searcher = new IndexSearcher(reader);
            Analyzer analyzer = new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29);
            CSETGlobalProperties props = new CSETGlobalProperties();
            SearchDocs search = new SearchDocs(props, new ResourceLibraryRepository(_context, props));
            return Ok(search.Search(searchRequest));
        }

        [HttpGet]
        [Route("api/ShowResourceLibrary")]
        public IActionResult ShowResourceLibrary()
        {
            var buildDocuments = new QuestionInformationTabData(_html, _context).GetBuildDocuments();
            return Ok(buildDocuments != null && buildDocuments.Count > 100);
        }

        [HttpGet]
        [Route("api/ResourceLibrary/tree")]
        public List<SimpleNode> GetTree()
        {
            IResourceLibraryRepository resource = new ResourceLibraryRepository(_context, new CSETGlobalProperties());
            return resource.GetTreeNodes();
        }

        [HttpGet]
        [Route("api/ResourceLibrary/doc")]
        public string GetFlowDoc(string type, int id)
        {
            // pull the flowdoc from the database
            string html = _flow.GetFlowDoc(type, id);

            return html;
        }
    }
}
