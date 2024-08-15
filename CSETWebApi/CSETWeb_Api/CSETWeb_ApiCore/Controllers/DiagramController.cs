//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Xml;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Diagram.Analysis;
using CSETWebCore.DataLayer.Model;
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
using System.Text;
using Microsoft.AspNetCore.Hosting;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Http.Extensions;
using CSETWebCore.Helpers;
using CSETWebCore.Model.Document;
using Microsoft.IdentityModel.Tokens;


namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DiagramController : ControllerBase
    {
        private readonly IDiagramManager _diagram;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IMaturityBusiness _maturity;
        private readonly IACETMaturityBusiness _acetMaturity;
        private readonly IHttpContextAccessor _http;
        private readonly IDataHandling _dataHandling;
        private readonly IACETDashboardBusiness _acet;
        private readonly IWebHostEnvironment _webHost;

        private CSETContext _context;

        private readonly object _object;


        public DiagramController(IDiagramManager diagram, ITokenManager token,
            IAssessmentBusiness assessment, IDataHandling dataHandling, 
            IMaturityBusiness maturity, IACETMaturityBusiness acetMaturity,
            IHttpContextAccessor http, IACETDashboardBusiness acet, IWebHostEnvironment webHost, CSETContext context)
        {
            _diagram = diagram;
            _token = token;
            _assessment = assessment;
            _dataHandling = dataHandling;
            _maturity = maturity;
            _acetMaturity = acetMaturity;
            _http = http;
            _acet = acet;
            _webHost = webHost;
            _context = context;
            _object = new object();
        }


        [CsetAuthorize]
        [Route("api/diagram/save")]
        [HttpPost]
        public void SaveDiagram([FromBody] DiagramRequest req)
        {
            // get the assessment ID from the JWT
            var assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
            DecodeDiagram(req);
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
                    _diagram.SaveDiagram((int)assessmentId, xDoc, req, true);
                }
                catch (Exception exc)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                }

            }
        }


        [CsetAuthorize]
        [Route("api/diagram/saveComponent")]
        [HttpPost]
        public void SaveDiagram([FromBody] mxGraphModelRootObject component)
        {
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
            _diagram.SaveComponent(component, (int)assessmentId);
        }


        [CsetAuthorize]
        [Route("api/diagram/analysis")]
        [HttpPost]
        public List<IDiagramAnalysisNodeMessage> PerformAnalysis([FromBody] DiagramRequest req)
        {
            // get the assessment ID from the JWT
            int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
            DecodeDiagram(req);
            return PerformAnalysis(req, assessmentId ?? 0);
        }


        private void DecodeDiagram(DiagramRequest req)
        {
            if (req.DiagramSvg != null)
            {
                byte[] data = Convert.FromBase64String(req.DiagramSvg);
                string decodedString = Encoding.UTF8.GetString(data);
                req.DiagramSvg = decodedString;


            }
            if (req.DiagramXml != null)
            {
                byte[] data = Convert.FromBase64String(req.DiagramXml);
                string decodedString = Encoding.UTF8.GetString(data);
                req.DiagramXml = decodedString;
            }
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
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                throw;
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
            var assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

            var response = _diagram.GetDiagram((int)assessmentId);

            var assessmentDetail = _assessment.GetAssessmentDetail((int)assessmentId);
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
            return Ok(new { diagram = _diagram.GetDiagramImage(assessmentId, requestUrl) });
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
            var assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

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

            var assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

            try
            {
                return _diagram.ImportOldCSETDFile(importRequest.DiagramXml, (int)assessmentId);

            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

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
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var vertices = _diagram.ProcessDiagramVertices(diagramXml, assessmentId ?? 0);

                var components = _diagram.GetDiagramComponents(vertices);
                return components;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

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
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

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
        public List<mxGraphModelRootObject> GetLinks()
        {
            try
            {
                int? assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
                var diagramXml = _diagram.GetDiagramXml((int)assessmentId);
                var edges = _diagram.ProcessDiagramEdges(diagramXml, assessmentId ?? 0);
                var links = _diagram.GetDiagramLinks(edges);
                return links;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

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
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

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
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return null; //BadRequest("No text available");
            }
            finally
            {
            }
        }


        /// <summary>
        /// Changes the component type for a single component.
        /// Normally called from the inventory when resolving unknowns.
        /// </summary>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/diagram/assetType")]
        public IActionResult UpdateComponentType([FromQuery] string guid, [FromQuery] string type, [FromQuery] string label)
        {
            int assessmentId = _token.AssessmentForUser();

            _diagram.UpdateComponentType(assessmentId, guid, type);

            if (!String.IsNullOrEmpty(label))
            {
                _diagram.UpdateComponentLabel(assessmentId, guid, label);
            }

            return Ok();
        }


        /// <summary>
        /// Changes the component type for a single component.
        /// Normally called from the inventory when resolving unknowns.
        /// </summary>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/diagram/changeShapeToComponent")]
        public IActionResult ChangeShapeToComponent([FromQuery] string type, [FromQuery] string id, [FromQuery] string label)
        {
            int assessmentId = _token.AssessmentForUser();
            _diagram.ChangeShapeToComponent(assessmentId, type, id, label);

            return Ok(GetComponents());
        }


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
            var assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);
            var stream = new ExcelExporter(_context, _dataHandling, _acetMaturity, _acet, _http).ExportToExcellDiagram(assessmentId ?? 0);
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
            var assessmentId = _token.PayloadInt(Constants.Constants.Token_AssessmentId);

            var templates = _diagram.GetDiagramTemplates();
            return templates;
        }


        /// <summary>
        /// Get all availabes alerts & advisories from the stored CSAF json files.
        /// Vendor is the top level class that houses products, which then holds vulnerabilites.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/vulnerabilities")]
        [HttpGet]
        public IActionResult GetDiagramVulnerabilities()
        {
            try
            {
                return Ok(_diagram.GetCsafVendors());
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return StatusCode(500);
            }
        }


        /// <summary>
        /// uploads new CSAF json files to Documents/DiagramVulnerabilities/CSAF to be used for network diagram alerts & advisories
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/vulnerabilities")]
        [HttpPost]
        public async System.Threading.Tasks.Task<IActionResult> UpdateDiagramVulnerabilities()
        {
            var multipartBoundary = HttpRequestMultipartExtensions.GetMultipartBoundary(Request);

            if (multipartBoundary == null)
            {
                // unsupported media type
                return StatusCode(415);
            }

            try
            {
                FileUploadStream fileUploader = new FileUploadStream();
                Dictionary<string, string> formValues = new Dictionary<string, string>();
                formValues.Add("fileItem", null);

                FileUploadStreamResult streamResult = await fileUploader.ProcessUploadStream(HttpContext.Request.HttpContext, formValues);
                foreach (var file in streamResult.FileResultList)
                {
                    if (!file.FileName.EndsWith(".json"))
                    {
                        return StatusCode(415);
                    }

                    if (!(file.FileSize > 0))
                    {
                        return BadRequest("JSON file cannot be empty.");
                    }

                    // Verfiy the json is a valid CommonSecurityAdvisoryFrameworkObject.
                    JsonSerializerSettings settings = new JsonSerializerSettings() { MissingMemberHandling = MissingMemberHandling.Error };
                    CommonSecurityAdvisoryFrameworkObject csafObj;
                    try
                    {
                        // This line will throw an error if the uploaded json does not follow the CSAF format.
                        csafObj = JsonConvert.DeserializeObject<CommonSecurityAdvisoryFrameworkObject>(Encoding.UTF8.GetString(file.FileBytes), settings);
                    }
                    catch (Exception e)
                    {
                        return BadRequest(e.Message);
                    }

                    var csafFile = _context.CSAF_FILE.FirstOrDefault(csafFile => csafFile.File_Name.ToLower() == file.FileName.ToLower());

                    if (csafFile == null)
                    {
                        csafFile = new CSAF_FILE
                        {
                            File_Name = file.FileName,
                            Data = file.FileBytes,
                            File_Size = file.FileSize,
                            Upload_Date = DateTime.Now,
                        };

                        _context.CSAF_FILE.Add(csafFile);
                    }
                    else
                    {
                        csafFile.Data = file.FileBytes;
                        csafFile.File_Size = file.FileSize;
                        csafFile.Upload_Date = DateTime.Now;
                    }

                    _context.SaveChanges();
                }
            }
            catch (Exception e)
            {
                return StatusCode(500, e.Message);
            }

            return Ok("CSAF file upload success.");
        }


        /// <summary>
        /// Saves a new vendor / updates a vendor that was added manually by the user.
        /// </summary>
        /// <param name="vendor">New vendor to persist</param>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/vulnerabilities/saveVendor")]
        [HttpPost]
        public IActionResult SaveCsafVendor([FromBody] CommonSecurityAdvisoryFrameworkVendor vendor)
        {
            try
            {
                return Ok(_diagram.SaveCsafVendor(vendor));
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return StatusCode(500);
            }
        }


        /// <summary>
        /// Deletes all CSAF files than contain a given vendor (this assumes each CSAF file only contains a single vendor).
        /// </summary>
        /// <param name="vendorName">Name of the vendor to be deleted</param>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/vulnerabilities/deleteVendor")]
        [HttpPost]
        public IActionResult DeleteCsafVendor([FromQuery] string vendorName)
        {
            try
            {
                _diagram.DeleteCsafVendor(vendorName);
                return Ok();
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return StatusCode(500);
            }
        }

        /// <summary>
        /// Deletes given product from CSAF files.
        /// </summary>
        /// <param name="productName">Name of the product to be deleted</param>
        /// <returns></returns>
        [CsetAuthorize]
        [Route("api/diagram/vulnerabilities/deleteProduct")]
        [HttpPost]
        public IActionResult DeleteCsafProduct([FromQuery] string vendorName, [FromQuery] string productName)
        {
            try
            {
                _diagram.DeleteCsafProduct(vendorName, productName);
                return Ok();
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return StatusCode(500);
            }
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
