//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
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
        public BasicReportData GetSecurityPlan()
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
        public BasicReportData GetExecutive()
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
        public MaturityReportData GetCMMCReport()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityReportData data = new MaturityReportData();
            data.AnalyzeMaturityData();
            data.MaturityModels = reportsDataManager.GetMaturityModelData();
            data.information = reportsDataManager.GetInformation();
            data.AnalyzeMaturityData();

            return data;
        }


   

        [HttpGet]
        [Route("api/reports/sitesummarycmmc")]
        public MaturityReportData GetSiteSummaryCMMCReport()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityReportData data = new MaturityReportData();
            
            data.MaturityModels = reportsDataManager.GetMaturityModelData();
            data.information = reportsDataManager.GetInformation();
            //data.StatementsAndReferences = reportsDataManager.GetStatementsAndReferences();
            data.AnalyzeMaturityData();

            return data;
        }




        //[HttpGet]
        //[Route("api/reports/rramain")]
        //public MaturityReportData GetRRAMainReport()
        //{
        //    int assessmentId = Auth.AssessmentForUser();
        //    ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
        //    MaturityReportData data = new MaturityReportData();
        //    data.AnalyzeMaturityData();
        //    data.MaturityModels = reportsDataManager.GetMaturityModelData();
        //    data.information = reportsDataManager.GetInformation();            
        //    data.AnalyzeMaturityData();

        //    return data;
        //}


        //[HttpGet]
        //[Route("api/reports/rradetail")]
        //public MaturityReportDetailData GetRRADetailReport()
        //{   
        //    int assessmentId = Auth.AssessmentForUser();

        //    using (CSET_Context context = new CSET_Context())
        //    {
        //        context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

        //        RRASummary summary = new RRASummary(context);
        //        MaturityReportDetailData data = new MaturityReportDetailData();
        //        data.RRASummaryOverall = summary.getSummaryOverall(context, assessmentId);                
        //        data.RRASummary = summary.getRRASummary(context, assessmentId);
        //        data.RRASummaryByGoal = summary.getRRASummaryByGoal(context, assessmentId);
        //        data.RRASummaryByGoalOverall = summary.getRRASummaryByGoalOverall(context, assessmentId);
        //        return data;
        //    }
        //}


        ///// <summary>
        ///// Returns a list of RRA questions.
        ///// </summary>
        ///// <returns></returns>
        //[HttpGet]
        //[Route("api/reports/rraquestions")]
        //public List<MaturityReportData.MaturityQuestion> GetRRAQuestions()
        //{
        //    var questions = new List<MaturityReportData.MaturityQuestion>();

        //    int assessmentId = Auth.AssessmentForUser();

        //    var mm = new MaturityManager();

        //    var resp = mm.GetMaturityQuestions(assessmentId, false, true);

        //    // get all supplemental info for questions, because it is not included in the previous method
        //    var dict = mm.GetReferences(assessmentId);


        //    resp.Groupings.First().SubGroupings.ForEach(goal => goal.Questions.ForEach(q =>
        //    {
        //        var newQ = new MaturityReportData.MaturityQuestion
        //        {
        //            Question_Title = q.DisplayNumber,
        //            Question_Text = q.QuestionText,
        //            Answer = new ANSWER() { Answer_Text = q.Answer },
        //            ReferenceText = dict[q.QuestionId]
        //        };

        //        questions.Add(newQ);
        //    }));

        //    return questions;
        //}



        [HttpGet]
        [Route("api/reports/getAltList")]
        public BasicReportData GetAltList()
        {
            int assessmentId = Auth.AssessmentForUser();
            // var assessment = 
            var reportsDataManager = new ReportsDataManager(assessmentId);
            var data = new BasicReportData();
            data.QuestionsWithAltJust = reportsDataManager.GetQuestionsWithAlternateJustification();
            data.MaturityQuestionsWithAlt = reportsDataManager.GetAlternatesList();
            data.information = reportsDataManager.GetInformation();
            return data;
        }


        [HttpGet]
        [Route("api/reports/discoveries")]
        public BasicReportData GetDiscoveries()
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
        public BasicReportData GetSiteSummary()
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
            data.QuestionsWithAltJust = reportsDataManager.GetQuestionsWithAlternateJustification();
            return data;
        }


        [HttpGet]
        [Route("api/reports/detail")]
        public BasicReportData GetDetail()
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
            data.QuestionsWithAltJust = reportsDataManager.GetQuestionsWithAlternateJustification();
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

            var aggManager = new BusinessLogic.AggregationManager();
            var assessmentList = aggManager.GetAssessmentsForAggregation((int)aggregationID);

            var aggregation = aggManager.GetAggregation((int)aggregationID);
            

            response.AggregationName = assessmentList.Aggregation.AggregationName;
            response.Information = new AggInformation()
            {
                Assessment_Date = aggregation.AggregationDate,
                Assessment_Name = aggregation.AggregationName,
                Assessor_Name = aggregation.AssessorName
            };

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

            AggregationManager agManager = new BusinessLogic.AggregationManager();

            var assessmentList = agManager.GetAssessmentsForAggregation((int)aggregationID);
            Aggregation ag =  agManager.GetAggregation((int)aggregationID);
            response.AggregationName = assessmentList.Aggregation.AggregationName;
            
            response.Information = new AggInformation()
            {
                Assessment_Name = ag.AggregationName,
                Assessment_Date = ag.AggregationDate,
                Assessor_Name = ag.AssessorName
            };

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


