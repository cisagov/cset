//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;


namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [CSETAuthorize]
    public class DiagramController : ApiController
    {
        /// <summary>
        /// Persists the diagram XML in the database.
        /// </summary>
        /// <param name="req"></param>
        [Route("api/diagram/save")]
        public void SaveDiagram([FromBody] DiagramRequest req)
        {
            BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager();
            dm.SaveDiagram(req.AssessmentID, req.DiagramXml);
        }


        /// <summary>
        /// Returns the diagram XML for the assessment.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        [Route("api/diagram/get")]
        public string GetDiagram([FromUri] int assessmentID)
        {
            BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager();
            return dm.GetDiagram(assessmentID);
        }
    }
}
