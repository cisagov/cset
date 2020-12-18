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
        public ACETReportData GetSecurityPlan()
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            ACETReportData data = new ACETReportData();
            data.DeficiencesList = reportsDataManager.getACETDeficiences();            
            data.information = reportsDataManager.GetInformation();
            return data;
        }
    }
}
