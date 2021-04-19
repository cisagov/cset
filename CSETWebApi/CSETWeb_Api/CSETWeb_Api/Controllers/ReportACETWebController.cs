//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
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
            data.DeficiencesList = reportsDataManager.GetMaturityDeficiences("ACET");
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
        public MaturityBasicReportData GetAnsweredQuestions()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.MatAnsweredQuestions = reportsDataManager.GetAnsweredQuestionList(assessmentId);
            data.information = reportsDataManager.GetInformation();
            return data;
        }

    }
}
