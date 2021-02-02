//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic;
using CSETWeb_Api.BusinessLogic.Models;
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
    public class ReportACETWebController : ApiController
    {
        [HttpGet]
        [Route("api/reports/acet/getDeficiencyList")]
        public MaturityBasicReportData GetDeficiencyList()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.DeficiencesList = reportsDataManager.getACETDeficiences();            
            data.information = reportsDataManager.GetInformation();
            return data;
        }

        [HttpGet]
        [Route("api/reports/acet/getAltList")]
        public MaturityBasicReportData GetAltList()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.AlternateList = reportsDataManager.getAlternatesList();
            data.information = reportsDataManager.GetInformation();
            return data;
        }
        [HttpGet]
        [Route("api/reports/acet/getCommentsMarked")]
        public MaturityBasicReportData GetCommentsMarked()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.Comments = reportsDataManager.getCommentsList(1);
            data.MarkedForReviewList = reportsDataManager.getMarkedForReviewList(1);
            data.information = reportsDataManager.GetInformation();
            return data;
        }
        [HttpGet]
        [Route("api/reports/acet/GetAssessmentInformation")]
        public MaturityBasicReportData GetAssessmentInformation()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.information = reportsDataManager.GetInformation();
            return data;
        }
        [HttpGet]
        [Route("api/reports/acet/getAnsweredQuestions")]
        public ACETReportData GetAnsweredQuestions()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            ACETReportData data = new ACETReportData();
            data.MatAnsweredQuestions = reportsDataManager.getAnsweredQuestionList(assessmentId);
            data.information = reportsDataManager.GetInformation();
            return data;
        }

    }
}
