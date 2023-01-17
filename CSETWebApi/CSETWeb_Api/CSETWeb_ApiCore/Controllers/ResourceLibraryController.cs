//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using CSETWebCore.Api.Models;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.RepositoryLibrary;
using CSETWebCore.DataLayer.Model;
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

            CSETGlobalProperties props = new CSETGlobalProperties(_context);
            SearchDocs search = new SearchDocs(props, new ResourceLibraryRepository(_context, props));
            return Ok(search.Search(searchRequest));
        }

        [HttpGet]
        [Route("api/ShowResourceLibrary")]
        public IActionResult ShowResourceLibrary()
        {
            var refBuilder = new Helpers.ReferencesBuilder(_context);
            var buildDocuments = refBuilder.GetBuildDocuments();
            return Ok(buildDocuments != null && buildDocuments.Count > 100);
        }

        [HttpGet]
        [Route("api/ResourceLibrary/tree")]
        public List<SimpleNode> GetTree()
        {
            IResourceLibraryRepository resource = new ResourceLibraryRepository(_context, new CSETGlobalProperties(_context));
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
