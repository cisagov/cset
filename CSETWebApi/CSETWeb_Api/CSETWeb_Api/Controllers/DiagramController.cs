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
using System.Xml;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Diagram;
using CSETWeb_Api.BusinessManagers;

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
        /// <param name="req"></param>
        [CSETAuthorize]
        [Route("api/diagram/save")]
        [HttpPost]
        public void SaveDiagram([FromBody] DiagramRequest req)
        {
            // get the assessment ID from the JWT
            TokenManager tm = new TokenManager();
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);

            BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager();
            XmlDocument xDoc = new XmlDocument();
            xDoc.LoadXml(req.DiagramXml);
            dm.SaveDiagram((int)assessmentId, xDoc, req.DiagramXml, req.LastUsedComponentNumber);
            //DiagramAnalysis analysis = new DiagramAnalysis();
            //analysis.PerformAnalysis(xDoc);
        }


        /// <summary>
        /// Returns the diagram XML for the assessment.
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/get")]
        [HttpGet]
        public DiagramResponse GetDiagram()
        {
            // get the assessment ID from the JWT
            TokenManager tm = new TokenManager();
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);

            var response = new DiagramResponse();

            BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager();
            response = dm.GetDiagram((int)assessmentId);

            var assessmentDetail = new AssessmentController().Get();
            response.AssessmentName = assessmentDetail.AssessmentName;

            return response;
        }


        /// <summary>
        /// Returns a boolean indicating the existence of a diagram.
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/has")]
        [HttpGet]
        public bool HasDiagram()
        {
            // get the assessment ID from the JWT
            TokenManager tm = new TokenManager();
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);

            BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager();
            return dm.HasDiagram((int)assessmentId);
        }


        /// <summary>
        /// Translates XML from CSETD file to XML for Draw.io.
        /// </summary>
        /// <param name="importRequest"></param>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/importcsetd")]
        [HttpPost]
        public string ImportCsetd([FromBody] DiagramRequest importRequest)
        {
            if (importRequest == null)
            {
                return "request payload not sent";
            }

            // get the assessment ID from the JWT
            TokenManager tm = new TokenManager();
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);

            try
            {
                var t = new TranslateCsetdToDrawio();
                string newDiagramXml = t.Translate(importRequest.DiagramXml).OuterXml;

                DiagramRequest req = new DiagramRequest
                {
                    DiagramXml = newDiagramXml
                };

                SaveDiagram(req);

                return newDiagramXml;
            }
            catch (Exception exc)
            {
                return exc.ToString();
            }
        }


        /// <summary>
        /// Returns the details for symbols.  This is used to build palettes and icons
        /// in the browser.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [Route("api/diagram/symbols/get")]
        [HttpGet]
        public List<ComponentSymbolGroup> GetComponentSymbols()
        {
            return new DiagramManager().GetComponentSymbols();
        }       
    }
}
