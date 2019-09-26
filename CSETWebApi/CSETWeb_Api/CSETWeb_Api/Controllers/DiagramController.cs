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
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;
using DataLayerCore.Model;
using System.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [CSETAuthorize]
    public class DiagramController : ApiController
    {
        /// <summary>
        /// Analyzes the diagram XML in the database.
        /// 
        /// RKW - THIS IS A STUB.  BARRY WILL BE PROVIDING THE REAL ONE.
        /// 
        /// </summary>
        /// <param name="req"></param>
        [CSETAuthorize]
        [Route("api/diagram/analyze")]
        [HttpPost]
        public List<IDiagramAnalysisNodeMessage> AnalyzeDiagram([FromBody] DiagramRequest req)
        {
            // RKW - this is a dummy response
            var NetworkWarnings = new List<IDiagramAnalysisNodeMessage>();
            DiagramAnalysisNodeMessage msg = new DiagramAnalysisNodeMessage();
            NetworkWarnings.Add(msg);

            return NetworkWarnings;
        }


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
            using (var db = new CSET_Context())
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                XmlDocument xDoc = new XmlDocument();
                if (string.IsNullOrEmpty(req.DiagramXml))
                {
                    req.DiagramXml = "<mxGraphModel grid=\"1\" gridSize=\"10\"><root><mxCell id=\"0\"><mxCell id=\"1\" parent=\"0\" /></mxCell></root></mxGraphModel>";
                }
                xDoc.LoadXml(req.DiagramXml);
                dm.SaveDiagram((int)assessmentId, xDoc, req.LastUsedComponentNumber, req.DiagramSvg);                
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
            using (var db = new CSET_Context())
            {
                BusinessManagers.DiagramManager dm = new BusinessManagers.DiagramManager(db);
                XmlDocument xDoc = new XmlDocument();
                xDoc.LoadXml(req.DiagramXml);

                DiagramAnalysis analysis = new DiagramAnalysis(db, assessmentId);
                return analysis.PerformAnalysis(xDoc);
                
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
    }
}
