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
using System.Web.Http.Results;
using System.Xml;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Diagram;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;
using DataLayerCore.Model;
using System.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using CSETWeb_Api.BusinessLogic.Models;

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
        [CSETAuthorize]
        [Route("api/diagram/save")]
        [HttpPost]
        public List<IDiagramAnalysisNodeMessage> SaveDiagram([FromBody] DiagramRequest req)
        {
            // get the assessment ID from the JWT
            TokenManager tm = new TokenManager();
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
            using (var db = new CSET_Context())
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                XmlDocument xDoc = new XmlDocument();
                if (string.IsNullOrEmpty(req.DiagramXml))
                {
                    req.DiagramXml = "<mxGraphModel grid=\"1\" gridSize=\"10\"><root><mxCell id=\"0\"><mxCell id=\"1\" /></mxCell></root></mxGraphModel>";
                }
                xDoc.LoadXml(req.DiagramXml);


                DiagramAnalysis analysis = new DiagramAnalysis(db);
                analysis.PerformAnalysis(xDoc);
                dm.SaveDiagram((int)assessmentId, xDoc, req.LastUsedComponentNumber, req.DiagramSvg);
                return analysis.NetworkWarnings;
            }
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
            using (var db = new CSET_Context())
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                response = dm.GetDiagram((int)assessmentId);
            }

            var assessmentDetail = new AssessmentController().Get();
            response.AssessmentName = assessmentDetail.AssessmentName;

            return response;
        }


        /// <summary>
        /// Returns the diagram image for the assessment.
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/getimage")]
        [HttpGet]
        public string GetDiagramImage()
        {
            int assessmentId = Auth.AssessmentForUser();
            using (var db = new CSET_Context())
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                return dm.GetDiagramImage(assessmentId);
            }
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

            using (var db = new CSET_Context())
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                return dm.HasDiagram((int)assessmentId);
            }
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

                Trace.Write(newDiagramXml);
                DiagramRequest req = new DiagramRequest
                {
                    DiagramXml = newDiagramXml
                };
                using (CSET_Context db = new CSET_Context())
                {
                    db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).First().Diagram_Markup = null;
                    string sql =
                    "delete [dbo].ASSESSMENT_DIAGRAM_COMPONENTS  where assessment_id = @id;" +
                    "delete [dbo].[DIAGRAM_CONTAINER] where assessment_id = @id;";
                    db.Database.ExecuteSqlCommand(sql,
                        new SqlParameter("@Id", assessmentId));
                    db.SaveChanges();
                }

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
            using (var db = new CSET_Context())
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                return dm.GetComponentSymbols();
            }
        }
        
        /// <summary>
        /// Returns list of diagram components
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/getComponents")]
        [HttpGet]
        public IHttpActionResult GetComponents()
        {
            try
            {
                TokenManager tm = new TokenManager();
                int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
                var dm = new DiagramManager(new CSET_Context());
                var diagramXml = dm.GetDiagramXml((int) assessmentId);
                var vertices = dm.ProcessDiagramVertices(diagramXml);
                var components = dm.GetDiagramComponents(vertices);
                return Ok(components);
            }
            catch (Exception ex)
            {
                return BadRequest("No components available");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Returns list of diagram zones
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/getZones")]
        [HttpGet]
        public IHttpActionResult GetZones()
        {
            try
            {
                TokenManager tm = new TokenManager();
                int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
                var dm = new DiagramManager(new CSET_Context());
                var diagramXml = dm.GetDiagramXml((int)assessmentId);
                var vertices = dm.ProcessDiagramVertices(diagramXml);
                var zones = dm.GetDiagramZones(vertices);
                return Ok(zones);
            }
            catch (Exception ex)
            {
                return BadRequest("No components available");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Returns list of diagram lines
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/getLinks")]
        [HttpGet]
        public IHttpActionResult GetLinks()
        {
            try
            {
                TokenManager tm = new TokenManager();
                int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
                var dm = new DiagramManager(new CSET_Context());
                var diagramXml = dm.GetDiagramXml((int)assessmentId);
                var edges = dm.ProcessDigramEdges(diagramXml);
                var links = dm.GetDiagramLinks(edges);
                return Ok(links);
            }
            catch (Exception ex)
            {
                return BadRequest("No components available");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Returns list of diagram shapes
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/getShapes")]
        [HttpGet]
        public IHttpActionResult GetShapes()
        {
            try
            {
                TokenManager tm = new TokenManager();
                int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
                var dm = new DiagramManager(new CSET_Context());
                var diagramXml = dm.GetDiagramXml((int)assessmentId);
                var vertices = dm.ProcessDiagramVertices(diagramXml);
                var shapes = dm.GetDiagramShapes(vertices);
                return Ok(shapes);
            }
            catch (Exception ex)
            {
                return BadRequest("No components available");
            }
            finally
            {
            }
        }

        [CSETAuthorize]
        [Route("api/diagram/saveDiagram")]
        [HttpPost]
        public IHttpActionResult SaveDiagram(mxGraphModelRootObject vertice)
        {
            TokenManager tm = new TokenManager();
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
            var dm = new DiagramManager(new CSET_Context());
            if (assessmentId != null)
            {
                dm.SaveComponent(vertice, (int)assessmentId);
            }

            return Ok();
        }
    }
}
