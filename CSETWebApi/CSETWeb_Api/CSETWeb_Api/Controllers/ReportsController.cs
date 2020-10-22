//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.ReportEngine;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{

    // [CSETWeb_Api.Helpers.CSETAuthorize]
    public class ReportsController : ApiController
    {
        [HttpGet]
        [Route("api/reports/securityplan")]
        public BasicReportData getSecurityPlan()
        {
            int assessmentId = Auth.AssessmentForUser();

            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            BasicReportData data = new BasicReportData();
            data.ControlList = reportsDataManager.GetControls();
            data.genSalTable = reportsDataManager.GetGenSals();
            data.information = reportsDataManager.GetInformation();
            data.salTable = reportsDataManager.GetSals();
            data.nistTypes = reportsDataManager.GetNistInfoTypes();
            data.nistSalTable = reportsDataManager.GetNistSals();
            data.Zones = reportsDataManager.GetDiagramZones();
            return data;
        }


        [HttpGet]
        [Route("api/reports/executive")]
        public BasicReportData getExecutive()
        {
            int assessmentId = Auth.AssessmentForUser();

            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            BasicReportData data = new BasicReportData();
            data.information = reportsDataManager.GetInformation();
            data.top5Categories = reportsDataManager.GetTop5Categories();
            data.top5Questions = reportsDataManager.GetTop5Questions();
            return data;
        }

        [HttpGet]
        [Route("api/reports/executivecmmc")]
        public MaturityReportData getCMMCReport()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityReportData data = new MaturityReportData();
            data.analyzeMaturityData();
            data.MaturityModels = reportsDataManager.getMaturityModelData();
            data.information = reportsDataManager.GetInformation();
            data.analyzeMaturityData();

            return data;
        }
        [HttpGet]
        [Route("api/reports/sitesummarycmmc")]
        public MaturityReportData getSiteSummaryCMMCReport()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityReportData data = new MaturityReportData();
            
            data.MaturityModels = reportsDataManager.getMaturityModelData();
            data.information = reportsDataManager.GetInformation();
            //data.StatementsAndReferences = reportsDataManager.GetStatementsAndReferences();
            data.analyzeMaturityData();

            return data;
        }

        [HttpGet]
        [Route("api/reports/discoveries")]
        public BasicReportData getDiscoveries()
        {
            int assessmentId = Auth.AssessmentForUser();

            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            BasicReportData data = new BasicReportData();
            data.information = reportsDataManager.GetInformation();
            data.Individuals = reportsDataManager.GetFindingIndividuals();
            return data;
        }


        [HttpGet]
        [Route("api/reports/sitesummary")]
        public BasicReportData getSiteSummary()
        {
            int assessmentId = Auth.AssessmentForUser();

            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            BasicReportData data = new BasicReportData();
            data.genSalTable = reportsDataManager.GetGenSals();
            data.information = reportsDataManager.GetInformation();
            data.salTable = reportsDataManager.GetSals();
            data.nistTypes = reportsDataManager.GetNistInfoTypes();
            data.nistSalTable = reportsDataManager.GetNistSals();
            data.DocumentLibraryTable = reportsDataManager.GetDocumentLibrary();
            data.RankedQuestionsTable = reportsDataManager.GetRankedQuestions();
            data.FinancialQuestionsTable = reportsDataManager.GetFinancialQuestions();
            data.QuestionsWithComments = reportsDataManager.GetQuestionsWithComments();
            data.QuestionsMarkedForReview = reportsDataManager.GetQuestionsMarkedForReview();
            data.QuestionsWithAlternateJustifi = reportsDataManager.GetQuestionsWithAlternateJustification();
            return data;
        }


        [HttpGet]
        [Route("api/reports/detail")]
        public BasicReportData getDetail()
        {
            int assessmentId = Auth.AssessmentForUser();

            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            BasicReportData data = new BasicReportData();
            data.genSalTable = reportsDataManager.GetGenSals();
            data.information = reportsDataManager.GetInformation();
            data.salTable = reportsDataManager.GetSals();
            data.nistTypes = reportsDataManager.GetNistInfoTypes();
            data.nistSalTable = reportsDataManager.GetNistSals();
            data.DocumentLibraryTable = reportsDataManager.GetDocumentLibrary();
            data.RankedQuestionsTable = reportsDataManager.GetRankedQuestions();
            data.QuestionsWithComments = reportsDataManager.GetQuestionsWithComments();
            data.QuestionsMarkedForReview = reportsDataManager.GetQuestionsMarkedForReview();
            data.QuestionsWithAlternateJustifi = reportsDataManager.GetQuestionsWithAlternateJustification();
            data.StandardsQuestions = reportsDataManager.GetQuestionsForEachStandard();
            data.ComponentQuestions = reportsDataManager.GetComponentQuestions();
            return data;
        }


        /// <summary>
        /// Returns data needed for the Trend report.  
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/trendreport")]
        public AggregationReportData GetTrendReport()
        {
            AggregationReportData response = new AggregationReportData();
            response.SalList = new List<BasicReportData.OverallSALTable>();            
            response.DocumentLibraryTable = new List<DocumentLibraryTable>();


            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return response;
            }

            var assessmentList = new BusinessLogic.AggregationManager()
                .GetAssessmentsForAggregation((int)aggregationID);

            response.AggregationName = assessmentList.Aggregation.AggregationName;

            foreach (var a in assessmentList.Assessments)
                {
                ReportsDataManager reportsDataManager = new ReportsDataManager(a.AssessmentId);


                // Incorporate SAL values into response
                var salTable = reportsDataManager.GetSals();

                var entry = new BasicReportData.OverallSALTable();
                response.SalList.Add(entry);
                entry.Alias = a.Alias;
                entry.OSV = salTable.OSV;
                entry.Q_CV = "";
                entry.Q_IV = "";
                entry.Q_AV = "";
                entry.LastSalDeterminationType = salTable.LastSalDeterminationType;

                if (salTable.LastSalDeterminationType != "GENERAL")
                {
                    entry.Q_CV = salTable.Q_CV;
                    entry.Q_IV = salTable.Q_IV;
                    entry.Q_AV = salTable.Q_AV;
                }


                // Document Library 
                var documentLibraryTable = reportsDataManager.GetDocumentLibrary();
                foreach (var docEntry in documentLibraryTable)
                {
                    docEntry.Alias = a.Alias;
                    response.DocumentLibraryTable.Add(docEntry);
                }
            }

            return response;
        }

        /// <summary>
        /// Returns data needed for the Compare report.  
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/comparereport")]
        public AggregationReportData GetCompareReport()
        {
            AggregationReportData response = new AggregationReportData();
            response.SalList = new List<BasicReportData.OverallSALTable>();
            response.DocumentLibraryTable = new List<DocumentLibraryTable>();


            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return response;
            }

            var assessmentList = new BusinessLogic.AggregationManager()
                .GetAssessmentsForAggregation((int)aggregationID);

            response.AggregationName = assessmentList.Aggregation.AggregationName;

            foreach (var a in assessmentList.Assessments)
            {
                ReportsDataManager reportsDataManager = new ReportsDataManager(a.AssessmentId);


                // Incorporate SAL values into response
                var salTable = reportsDataManager.GetSals();

                var entry = new BasicReportData.OverallSALTable();
                response.SalList.Add(entry);
                entry.Alias = a.Alias;
                entry.OSV = salTable.OSV;
                entry.Q_CV = "";
                entry.Q_IV = "";
                entry.Q_AV = "";
                entry.LastSalDeterminationType = salTable.LastSalDeterminationType;

                if (salTable.LastSalDeterminationType != "GENERAL")
                {
                    entry.Q_CV = salTable.Q_CV;
                    entry.Q_IV = salTable.Q_IV;
                    entry.Q_AV = salTable.Q_AV;
                }


                // Document Library 
                var documentLibraryTable = reportsDataManager.GetDocumentLibrary();
                foreach (var docEntry in documentLibraryTable)
                {
                    docEntry.Alias = a.Alias;
                    response.DocumentLibraryTable.Add(docEntry);
                }
            }

            return response;
        }


        /// <summary>
        /// Returns a Q or R indicating the assessment's application mode, Questions or Requirements.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        protected string GetApplicationMode(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var mode = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).Select(x => x.Application_Mode).FirstOrDefault();

                if (mode == null)
                {
                    // default to Questions mode
                    mode = "Q";
                    SetMode(mode);
                }

                return mode;
            }
        }


        private void SetMode(string mode)
        {
            int assessmentId = Auth.AssessmentForUser();
            QuestionsManager qm = new QuestionsManager(assessmentId);
            qm.SetApplicationMode(mode);
        }
    }
}


