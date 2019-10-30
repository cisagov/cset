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
using System.Net.Http.Headers;
using CSETWeb_Api.BusinessLogic.Models;
using ExportCSV;
using System.Threading;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [CSETAuthorize]
    public class DiagramController : ApiController
    {
        private static readonly object _object = new object();

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
            lock (_object)
            {
                using (var db = new CSET_Context())
                {
                    try
                    {
                        BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                        XmlDocument xDoc = new XmlDocument();
                        if (string.IsNullOrEmpty(req.DiagramXml))
                        {
                            req.DiagramXml = "<mxGraphModel grid=\"1\" gridSize=\"10\"><root><mxCell id=\"0\"><mxCell id=\"1\" parent=\"0\" /></mxCell></root></mxGraphModel>";
                        }
                        xDoc.LoadXml(req.DiagramXml);
                        dm.SaveDiagram((int)assessmentId, xDoc, req);
                    }
                    catch (Exception e)
                    {
                        throw e;
                    }
                }
            }

        }

        [CSETAuthorize]
        [Route("api/diagram/warnings")]
        [HttpPost]
        public List<IDiagramAnalysisNodeMessage> PerformAnalysis([FromBody] DiagramRequest req)
        {
            // get the assessment ID from the JWT
            TokenManager tm = new TokenManager();
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
            return performAnalysis(req, assessmentId ?? 0);

        }

        public List<IDiagramAnalysisNodeMessage> performAnalysis(DiagramRequest req, int assessmentId)
        {
            try
            {
                var messages = new List<IDiagramAnalysisNodeMessage>();
                if (!string.IsNullOrEmpty(req.DiagramXml))
                {
                    using (var db = new CSET_Context())
                    {
                        BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                        XmlDocument xDoc = new XmlDocument();
                        xDoc.LoadXml(req.DiagramXml);

                        DiagramAnalysis analysis = new DiagramAnalysis(db, assessmentId);
                        messages = analysis.PerformAnalysis(xDoc);
                    }
                }
                return messages;
            }catch(Exception e)
            {
                throw e;
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
                using (CSET_Context db = new CSET_Context())
                {
                    DiagramManager dm = new DiagramManager(db);
                    return dm.ImportOldCSETDFile(importRequest.DiagramXml, (int)assessmentId);
                }
                
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
        /// Returns the details for symbols.  This is used to build palettes and icons
        /// in the browser.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [Route("api/diagram/symbols/getAll")]
        [HttpGet]
        public IHttpActionResult GetAllSymbols()
        {
            using (var db = new CSET_Context())
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                return Ok(dm.GetAllComponentSymbols());
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

                var diagramXml = dm.GetDiagramXml((int)assessmentId);
                var vertices = dm.ProcessDiagramVertices(diagramXml, assessmentId ?? 0);

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
                var vertices = dm.ProcessDiagramVertices(diagramXml, assessmentId ?? 0);
                var zones = dm.GetDiagramZones(vertices);
                return Ok(zones);
            }
            catch (Exception ex)
            {
                return BadRequest("No zones available");
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
                var edges = dm.ProcessDigramEdges(diagramXml, assessmentId ?? 0);
                var links = dm.GetDiagramLinks(edges);
                return Ok(links);
            }
            catch (Exception ex)
            {
                return BadRequest("No links available");
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
                var vertices = dm.ProcessDiagramShapes(diagramXml, assessmentId ?? 0);
                var shapes = dm.GetDiagramShapes(vertices);
                return Ok(shapes);
            }
            catch (Exception ex)
            {
                return BadRequest("No shapes available");
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
        [Route("api/diagram/getTexts")]
        [HttpGet]
        public IHttpActionResult GetTexts()
        {
            try
            {
                TokenManager tm = new TokenManager();
                int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
                var dm = new DiagramManager(new CSET_Context());
                var diagramXml = dm.GetDiagramXml((int)assessmentId);
                var vertices = dm.ProcessDiagramShapes(diagramXml, assessmentId ?? 0);
                var texts = dm.GetDiagramText(vertices);
                return Ok(texts);
            }
            catch (Exception ex)
            {
                return BadRequest("No text available");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Generates an Excel spreadsheet with a row for every assessment that
        /// the current user has access to that uses the ACET standard.
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [CSETAuthorize]
        [HttpGet]
        [Route("api/diagram/export")]
        public HttpResponseMessage GetExcelExportDiagram()
        {
            TokenManager tm = new TokenManager();
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
            var stream = new ExcelExporter().ExportToExcellDiagram(assessmentId ?? 0);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StreamContent(stream)
            };
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            return result;
        }

        /// <summary>
        /// get cset diagram templates
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/diagram/templates")]
        [HttpGet]
        public IHttpActionResult GetTemplates()
        {
            var tm = new TokenManager();
            var userId = tm.PayloadInt(Constants.Token_UserId);

            var dm = new DiagramManager(new CSET_Context());
            var templates = dm.GetDiagramTemplates();
            return Ok(templates);
        }

        /// <summary>
        /// Returns the details for symbols.  This is used to build palettes and icons
        /// in the browser.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [Route("api/diagram/testqueue")]
        [HttpPost]
        public int testQueue([FromBody]int requestId)
        {
            lock (_object)
            {
                Thread.Sleep(1000);
                return requestId;
            }
        }
    }
}
