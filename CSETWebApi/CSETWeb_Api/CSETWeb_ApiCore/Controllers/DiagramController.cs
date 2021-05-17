using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Xml;
using CSETWebCore.Authorization;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Diagram;
using Microsoft.AspNetCore.Authorization;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DiagramController : ControllerBase
    {
        private readonly IDiagramManager _diagram;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private CSETContext _context;

        private readonly object _object;

        public DiagramController(IDiagramManager diagram, ITokenManager token, 
            IAssessmentBusiness assessment, CSETContext context)
        {
            _diagram = diagram;
            _token = token;
            _assessment = assessment;
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
                }
                catch (Exception e)
                {
                    throw e;
                }

            }

        }

        [CsetAuthorize]
        [Route("api/diagram/analysis")]
        [HttpPost]
        public IActionResult PerformAnalysis([FromBody] DiagramRequest req)
        {
            // get the assessment ID from the JWT
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
            return Ok(PerformAnalysis(req, assessmentId ?? 0));

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
        public IActionResult GetDiagram()
        {
            // get the assessment ID from the JWT
            int userId = (int)_token.PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

            var response = new DiagramResponse();
 
            response = _diagram.GetDiagram((int)assessmentId);

            var assessmentDetail = _assessment.GetAssessmentDetail((int) assessmentId);
            response.AssessmentName = assessmentDetail.AssessmentName;

            return Ok(response);
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
            return Ok(_diagram.GetDiagramImage(assessmentId));
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
        public IActionResult ImportCsetd([FromBody] DiagramRequest importRequest)
        {
            if (importRequest == null)
            {
                return BadRequest("request payload not sent");
            }

            int userId = (int)_token.PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

            try
            {
                return Ok(_diagram.ImportOldCSETDFile(importRequest.DiagramXml, (int)assessmentId));

            }
            catch (Exception exc)
            {
                return BadRequest(exc.ToString());
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
        public IActionResult GetComponentSymbols()
        {
            return Ok(_diagram.GetComponentSymbols());
        }

        /// <summary>
        /// Returns the details for symbols.  This is used to build palettes and icons
        /// in the browser.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [Route("api/diagram/symbols/getAll")]
        [HttpGet]
        public IActionResult GetAllSymbols()
        {
            return Ok(_diagram.GetAllComponentSymbols());
        }

        /// <summary>
        /// Returns list of diagram components
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/getComponents")]
        [HttpGet]
        public IActionResult GetComponents()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramVertices(diagramXml, assessmentId ?? 0);

                var components = _diagram.GetDiagramComponents(vertices);
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
        [CsetAuthorize]
        [Route("api/diagram/getZones")]
        [HttpGet]
        public IActionResult GetZones()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramVertices(diagramXml, assessmentId ?? 0);
                var zones = _diagram.GetDiagramZones(vertices);
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
        [CsetAuthorize]
        [Route("api/diagram/getLinks")]
        [HttpGet]
        public IActionResult GetLinks()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var edges = _diagram.ProcessDiagramEdges(diagramXml, assessmentId ?? 0);
                var links = _diagram.GetDiagramLinks(edges);
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
        [CsetAuthorize]
        [Route("api/diagram/getShapes")]
        [HttpGet]
        public IActionResult GetShapes()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramShapes(diagramXml, assessmentId ?? 0);
                var shapes = _diagram.GetDiagramShapes(vertices);
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
        [CsetAuthorize]
        [Route("api/diagram/getTexts")]
        [HttpGet]
        public IActionResult GetTexts()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramShapes(diagramXml, assessmentId ?? 0);
                var texts = _diagram.GetDiagramText(vertices);
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

        //TODO: Fix excel export
        /// <summary>
        /// Generates an Excel spreadsheet with a row for every assessment that
        /// the current user has access to that uses the ACET standard.
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [CsetAuthorize]
        [HttpGet]
        [Route("api/diagram/export")]
        public IActionResult GetExcelExportDiagram()
        {
            //int? assessmentId = _token.PayloadInt(Constants.Token_AssessmentId);
            //var stream = new ExcelExporter().ExportToExcellDiagram(assessmentId ?? 0);
            //stream.Flush();
            //stream.Seek(0, System.IO.SeekOrigin.Begin);
            //HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK)
            //{
            //    Content = new StreamContent(stream)
            //};
            //result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            //return result;
            return Ok();
        }

        /// <summary>
        /// get cset diagram templates
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/templates")]
        [HttpGet]
        public IActionResult GetTemplates()
        {
            var userId = _token.PayloadInt(Constants.Constants.Token_UserId);

            var templates = _diagram.GetDiagramTemplates();
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
