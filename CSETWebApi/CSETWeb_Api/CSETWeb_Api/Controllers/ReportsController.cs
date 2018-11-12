//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.ReportEngine;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
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
            data.QuestionsWithCommentsTable = reportsDataManager.getQuestionsWithCommentsOrMarkedForReview();
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
            data.QuestionsWithCommentsTable = reportsDataManager.getQuestionsWithCommentsOrMarkedForReview();
            data.QuestionsWithAlternateJustifi = reportsDataManager.GetQuestionsWithAlternateJustification();
            data.StandardsQuestions = reportsDataManager.GetQuestionsForEachStandard();
            return data;
        }

        protected string GetApplicationMode(int assessmentId)
        {
            using (var db = new DataLayer.CSETWebEntities())
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


