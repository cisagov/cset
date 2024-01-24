//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Dashboard;
//using CSETWebCore.Interfaces.Dashboard;
using CSETWebCore.Model.Dashboard;
using System.Threading.Tasks;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Analysis;
using Snickler.EFCore;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Model.Question;
using DataRowsAnalytics = CSETWebCore.Model.Dashboard.DataRowsAnalytics;
using CSETWebCore.Interfaces.Analytics;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Model.Assessment;

//using CSETWebCore.Interfaces.Dashboard;
// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CSETWebCore.Api.Controllers
{



    [ApiController]
    public class DashboardTsaController : ControllerBase
    {

        private readonly IConfiguration config;
        private DashboardBusiness _dashboardBusiness;
        private readonly CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly IAnalyticsBusiness _analytics;
        private readonly IDemographicBusiness _demographic;
        public DashboardTsaController(IConfiguration config, CSETContext context, ITokenManager tokenManager, IAnalyticsBusiness analytics, IDemographicBusiness demographic)
        {
            this.config = config;
            _context = context;
            _dashboardBusiness = new DashboardBusiness(_context);
            _tokenManager = tokenManager;
            _analytics = analytics;
            _demographic = demographic;
        }

        // [HttpGet]
        // [Route("api/TSA/getSectors")]
        // public async Task<IActionResult> GetSectors()
        // {
        //     var sectors = await _dashboardBusiness.GetSectors();
        //     var flattenSectors = sectors.Select(x => new TreeView
        //     {
        //         Name = x.SectorName,
        //         Children = x.Industries?.Select(y => new TreeView { Name = y }).ToList()
        //     }).ToList();
        //     flattenSectors.Insert(0, new TreeView { Name = "All Sectors", Children = null });
        //     return Ok(flattenSectors);
        //
        // }

        [HttpGet]
        [Route("api/TSA/analyticsMaturityDashboard")]
        public IActionResult analyticsMaturityDashboard(int maturity_model_id, int? sectorId, int? industryId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            ChartDataTSA chartData = new ChartDataTSA();

            var data = _analytics.getMaturityDashboardData(maturity_model_id, sectorId, industryId);
            var percentage = _analytics
                .GetMaturityGroupsForAssessment(assessmentId, maturity_model_id).ToList();
            chartData.DataRowsMaturity = data;
            chartData.data = (from a in percentage
                              select (double)a.Percentage).ToList();


            chartData.Labels = (from an in data
                                orderby an.Question_Group_Heading
                                select an.Question_Group_Heading).Distinct().ToList();
            foreach (var item in data)
            {
                chartData.data.Add(item.average);
            }


            return Ok(chartData);
        }

        [HttpGet]
        [Route("api/TSA/getStandardList")]
        public IActionResult getStandardList()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var standardList = _analytics.GetStandardList(assessmentId);
            return Ok(standardList);
        }
        [HttpGet]
        [Route("api/TSA/getSectorIndustryStandardsTSA")]
        public IActionResult GetStandardsResultsByCategory1(int? sectorId, int? industryId)
        {

            int assessmentId = _tokenManager.AssessmentForUser();
            var standardList = _analytics.GetStandardList(assessmentId);
            // var standardMinMaxAvg = _analytics.GetStandardMinMaxAvg(assessmentId,"TSA2018", sectorId=null, industryId=null);
            ChartDataTSA[] chartDatas = new ChartDataTSA[standardList.Count()];
            int i = 0;
            foreach (var setname in standardList)
            {
                ChartDataTSA chartData = new ChartDataTSA();

                var standardMinMaxAvg = _analytics.GetStandardMinMaxAvg(assessmentId, setname.Set_Name, sectorId, industryId);
                var standardsingleaverage = _analytics.GetStandardSingleAvg(assessmentId, setname.Set_Name);

                chartData.data = (from a in standardsingleaverage
                                  select a.average).ToList();


                chartData.DataRowsStandard = standardMinMaxAvg;
                chartData.StandardList = standardList;
                chartData.label = setname.Short_Name;
                foreach (var c in standardMinMaxAvg)
                {
                    chartData.Labels.Add(c.QUESTION_GROUP_HEADING);
                }

                chartDatas[i++] = chartData;
            }
            return Ok(chartDatas);
        }
        [HttpGet]
        [Route("api/TSA/updateChart")]
        public IActionResult UpdateChart([FromBody] Demographics demographics)
        {
            demographics.AssessmentId = _tokenManager.AssessmentForUser();
            return Ok(_demographic.SaveDemographics(demographics));
        }

    }
}

