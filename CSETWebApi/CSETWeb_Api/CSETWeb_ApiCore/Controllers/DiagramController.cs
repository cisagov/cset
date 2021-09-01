using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Xml;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.DataLayer;
using CSETWebCore.ExportCSV;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.ReportEngine;
using CSETWebCore.Model.Diagram;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Primitives;
using System.Net.Http.Headers;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DiagramController : ControllerBase
    {
        private readonly IDiagramManager _diagram;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IMaturityBusiness _maturity;
        private readonly IHttpContextAccessor _http;
        private readonly IDataHandling _dataHandling;
        private readonly IACETDashboardBusiness _acet;

        private CSETContext _context;

        private readonly object _object;

        public DiagramController(IDiagramManager diagram, ITokenManager token, 
            IAssessmentBusiness assessment, IDataHandling dataHandling, IMaturityBusiness maturity, 
            IHttpContextAccessor http, IACETDashboardBusiness acet, CSETContext context)
        {
            _diagram = diagram;
            _token = token;
            _assessment = assessment;
            _dataHandling = dataHandling;
            _maturity = maturity;
            _http = http;
            _acet = acet;
            _context = context;
            _object = new object();
        }

        [CsetAuthorize]
        [Route("api/diagram/save")]
        [HttpPost]
        public void SaveDiagram([FromBody] DiagramRequest req)
        {
            // get the assessment ID from the JWT
            int userId = (int)_token.PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
            lock (_object)
            {
                try
                {
                    XmlDocument xDoc = new XmlDocument();
                    if (string.IsNullOrEmpty(req.DiagramXml))
                    {
                        req.DiagramXml = "<mxGraphModel grid=\"1\" gridSize=\"10\"><root><mxCell id=\"0\"><mxCell id=\"1\" parent=\"0\" /></mxCell></root></mxGraphModel>";
                    }
                    xDoc.LoadXml(req.DiagramXml);
                    _diagram.SaveDiagram((int)assessmentId, xDoc, req);
                    //return //Ok();
                }
                catch (Exception e)
                {
                    //return null;  //BadRequest(e.Message);
                }

            }

        }

        [CsetAuthorize]
        [Route("api/diagram/analysis")]
        [HttpPost]
        public List<IDiagramAnalysisNodeMessage> PerformAnalysis([FromBody] DiagramRequest req)
        {
            // get the assessment ID from the JWT
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
            return PerformAnalysis(req, assessmentId ?? 0);

        }

        private List<IDiagramAnalysisNodeMessage> PerformAnalysis(DiagramRequest req, int assessmentId)
        {
            try
            {
                var messages = new List<IDiagramAnalysisNodeMessage>();
                if (!string.IsNullOrEmpty(req.DiagramXml))
                {
                    // persist the analysis switch setting
                        var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).First();
                        assessment.AnalyzeDiagram = req.AnalyzeDiagram;
                        _context.SaveChanges();

                        XmlDocument xDoc = new XmlDocument();
                        xDoc.LoadXml(req.DiagramXml);

                        DiagramAnalysis analysis = new DiagramAnalysis(_context, assessmentId);
                        messages = analysis.PerformAnalysis(xDoc);
                }

                return messages;
            }
            catch (Exception e)
            {
                throw e;
            }

        }


        /// <summary>
        /// Returns the diagram XML for the assessment.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/get")]
        [HttpGet]
        public DiagramResponse GetDiagram()
        {
            // get the assessment ID from the JWT
            int userId = (int)_token.PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

            var response = new DiagramResponse();
 
            response = _diagram.GetDiagram((int)assessmentId);

            var assessmentDetail = _assessment.GetAssessmentDetail((int) assessmentId);
            response.AssessmentName = assessmentDetail.AssessmentName;

            return response;
        }


        /// <summary>
        /// Returns the diagram image for the assessment.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/getimage")]
        [HttpGet]
        public IActionResult GetDiagramImage()
        {
            int assessmentId = _token.AssessmentForUser();
            string requestUrl = $"{Request.Scheme}://{Request.Host.Value}{Request.Path}";
            return Ok(new { diagram = _diagram.GetDiagramImage(assessmentId, requestUrl)});
        }


        /// <summary>
        /// Returns a boolean indicating the existence of a diagram.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/has")]
        [HttpGet]
        public IActionResult HasDiagram()
        {
            // get the assessment ID from the JWT
            int userId = (int)_token.PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

            return Ok(_diagram.HasDiagram((int)assessmentId));

        }


        /// <summary>
        /// Translates XML from CSETD file to XML for Draw.io.
        /// </summary>
        /// <param name="importRequest"></param>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/importcsetd")]
        [HttpPost]
        public string ImportCsetd([FromBody] DiagramRequest importRequest)
        {
            if (importRequest == null)
            {
                return string.Empty;//BadRequest("request payload not sent");
            }

            int userId = (int)_token.PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

            try
            {
                return _diagram.ImportOldCSETDFile(importRequest.DiagramXml, (int)assessmentId);

            }
            catch (Exception exc)
            {
                return string.Empty; //BadRequest(exc.ToString());
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
            return _diagram.GetComponentSymbols();
        }

        /// <summary>
        /// Returns the details for symbols.  This is used to build palettes and icons
        /// in the browser.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [Route("api/diagram/symbols/getAll")]
        [HttpGet]
        public List<ComponentSymbol> GetAllSymbols()
        {
            return _diagram.GetAllComponentSymbols();
        }

        /// <summary>
        /// Returns list of diagram components
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/getComponents")]
        [HttpGet]
        public List<mxGraphModelRootObject> GetComponents()
        {
            try
            {int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramVertices(diagramXml, assessmentId ?? 0);

                var components = _diagram.GetDiagramComponents(vertices);
                return components;
            }
            catch (Exception)
            {
                return null; //BadRequest("No components available");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Returns list of diagram zones
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/getZones")]
        [HttpGet]
        public List<mxGraphModelRootObject> GetZones()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramVertices(diagramXml, assessmentId ?? 0);
                var zones = _diagram.GetDiagramZones(vertices);
                return zones;
            }
            catch (Exception)
            {
                return null; // BadRequest("No zones available");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Returns list of diagram lines
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/getLinks")]
        [HttpGet]
        public List<mxGraphModelRootMxCell> GetLinks()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var edges = _diagram.ProcessDiagramEdges(diagramXml, assessmentId ?? 0);
                var links = _diagram.GetDiagramLinks(edges);
                return links;
            }
            catch (Exception)
            {
                return null; //BadRequest("No links available");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Returns list of diagram shapes
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/getShapes")]
        [HttpGet]
        public List<mxGraphModelRootMxCell> GetShapes()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramShapes(diagramXml, assessmentId ?? 0);
                var shapes = _diagram.GetDiagramShapes(vertices);
                return shapes;
            }
            catch (Exception)
            {
                return null;  //BadRequest("No shapes available");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Returns list of diagram shapes
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/getTexts")]
        [HttpGet]
        public List<mxGraphModelRootMxCell> GetTexts()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramShapes(diagramXml, assessmentId ?? 0);
                var texts = _diagram.GetDiagramText(vertices);
                return texts;
            }
            catch (Exception)
            {
                return null; //BadRequest("No text available");
            }
            finally
            {
            }
        }

        //TODO: Fix excel export
        /// <summary>
        /// Generates an Excel spreadsheet with a row for every assessment that
        /// the current user has access to that uses the ACET standard.
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [CsetAuthorize]
        [HttpGet]
        [Route("api/diagram/exportExcel")]
        public IActionResult GetExcelExportDiagram()
        {
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
            var stream = new ExcelExporter(_context,_dataHandling, _maturity, _acet, _http).ExportToExcellDiagram(assessmentId ?? 0);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);
            return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        }

        /// <summary>
        /// get cset diagram templates
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/templates")]
        [HttpGet]
        public IEnumerable<DiagramTemplate> GetTemplates()
        {
            var userId = _token.PayloadInt(Constants.Constants.Token_UserId);

            var templates = _diagram.GetDiagramTemplates();
            return templates;
        }

        /// <summary>
        /// Returns the details for symbols.  This is used to build palettes and icons
        /// in the browser.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [Route("api/diagram/testqueue")]
        [HttpPost]
        public int testQueue([FromBody] int requestId)
        {
            lock (_object)
            {
                Thread.Sleep(1000);
                return requestId;
            }
        }
    }
}
