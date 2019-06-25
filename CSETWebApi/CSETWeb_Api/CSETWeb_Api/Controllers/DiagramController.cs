using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class DiagramController : ApiController
    {
        /// <summary>
        /// Persists the diagram XML in the database.
        /// </summary>
        /// <param name="diagramXml"></param>
        [Route("api/diagram/save")]
        public void SaveDiagram([FromBody] string diagramXml)
        {
            // DIAGRAM_MARKUP

        }
    }
}
