using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Dashboard;
//using CSETWebCore.Interfaces.Dashboard;
using CSETWebCore.Model.Dashboard;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
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
        
        [HttpGet]
        [Route("api/TSA/getSectors")]
        public async Task<IActionResult> GetSectors()
        {
            var sectors = await _dashboardBusiness.GetSectors();
            var flattenSectors = sectors.Select(x => new TreeView
            {
                Name = x.SectorName,
                Children = x.Industries?.Select(y => new TreeView { Name = y }).ToList()
            }).ToList();
            flattenSectors.Insert(0, new TreeView { Name = "All Sectors", Children = null });
            return Ok(flattenSectors);

        }

        [HttpGet]
        [Route("api/TSA/analyticsMaturityDashboard")]
        public IActionResult analyticsMaturityDashboard(int maturity_model_id)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            ChartDataTSA chartData = new ChartDataTSA();
            
            var data = _analytics.getMaturityDashboardData(maturity_model_id);
            var percentage = _analytics
                .GetMaturityGroupsForAssessment(assessmentId, maturity_model_id).ToList();
            chartData.DataRows = data;
            chartData.data = (from a in percentage
                select (double) a.Percentage).ToList();

            
            chartData.Labels = (from an in data
                                orderby an.title
                                select an.title).Distinct().ToList();
            foreach(var item in data)
            {
                chartData.data.Add(item.avg??0);
            }
                                        

            return Ok(chartData);
        }

        [HttpGet]
        [Route("api/TSA/DashboardStandarsByCategoryTSA")]
        public IActionResult GetStandardsResultsByCategory(string selectedSector)
        {
            
            //var dashboardChartData =  _dashboardBusiness.GetDashboardData(selectedSector);
            // var rawdata = _context.usp_GetRawCountsForEachAssessment_Standards().ToList();
            var getMedian = _context.analytics_getMedianOverall().ToList();
            int assessmentId = _tokenManager.AssessmentForUser();
       
            ChartDataTSA chartData = new ChartDataTSA();
            ChartDataTSA minMaxChartData = new ChartDataTSA();
            // chartData.dataSets.Add(minMaxChartData);
            // minMaxChartData.type = "scatter";
            // var sectorIndustryMinMax = _context.analytics_getMinMaxAverageForSectorIndustryGroup(15, 67);


            // var sectorIndustryMinMax12 = _context.analytics_getMinMaxAverageForSectorIndustryGroup(15, 67);

            // var standardsList = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId).ToList();
            var standardList = _analytics.GetStandardList(assessmentId);
            // var resultsList  = from standards in _context.AVAILABLE_STANDARDS
            //     join sets in _context.SETS
            //         on standards.Set_Name equals sets.Set_Name
            //     where  standards.Assessment_Id == assessmentId
            // select sets;
            //
            chartData.StandardList = standardList;
            _context.LoadStoredProc("[analytics_getStandardsResultsByCategory]")
                .WithSqlParam("assessment_Id", assessmentId)
                .ExecuteStoredProc((Action<EFExtensions.SprocResults>)((handler) =>
                {
                    var result = handler.ReadToList<Model.Aggregation.analytics_getStandardsResultsByCategory>();
                    var labels = (from Model.Aggregation.analytics_getStandardsResultsByCategory an in result
                        orderby an.Question_Group_Heading
                        select an.Question_Group_Heading).Distinct().ToList();
                    
                    chartData.DataRows = new List<DataRowsAnalytics>();
                    foreach (string c in labels)
                    {
                        //    chartData.data.Add((double) c.prc);
                        chartData.Labels.Add(c);
                        //    chartData.DataRows.Add(new DataRows()
                        //    {
                        //        failed =c.yaCount,
                        //        percent = c.prc,
                        //        total = c.Actualcr,
                        //        title = c.Question_Group_Heading                            
                        //   });

                    }

                    ColorsList colors = new ColorsList();

                    var sets = (from Model.Aggregation.analytics_getStandardsResultsByCategory an in result
                        select new { an.Set_Name, an.Short_Name }).Distinct();
                    foreach (var set in sets)
                    {

                        ChartDataTSA nextChartData = new ChartDataTSA();
                        chartData.dataSets.Add(nextChartData);
                        //nextChartData.DataRows = new List<DataRowsTSA>();
                        var nextSet = (from Model.Aggregation.analytics_getStandardsResultsByCategory an in result
                            where an.Set_Name == set.Set_Name
                            orderby an.Question_Group_Heading
                            select an).ToList();
                        nextChartData.label = set.Short_Name;
                        nextChartData.backgroundColor = colors.getNext(set.Set_Name);
                        //nextChartData.backgroundColor = "#FFC106";
                        foreach (Model.Aggregation.analytics_getStandardsResultsByCategory c in nextSet)
                        {
                            chartData.DataRows.Add(new DataRowsAnalytics()
                            {

                                failed = c.yaCount,
                                percent = c.prc,
                                total = c.Actualcr,
                                title = c.Question_Group_Heading,

                            });  
                            nextChartData.data.Add((double)c.prc);
                            //nextChartData.Labels.Add(c.Question_Group_Heading);
                            nextChartData.DataRows.Add((DataRowsAnalytics)new Model.Dashboard.DataRowsAnalytics()
                            {
                                    
                                failed = c.yaCount,
                                percent = c.prc,
                                total = c.Actualcr,
                                title = c.Question_Group_Heading,

                                   
                            });
                        }
                        foreach (var a in getMedian)
                        {
                            minMaxChartData.DataRows.Add((DataRowsAnalytics)new Model.Dashboard.DataRowsAnalytics()
                            {

                                min = a.Min,
                                max = a.Max,
                                percent = (decimal?)a.Median,
                                   
                                  
                            });
                        }

                    }
                   
                }));

            return Ok(chartData);
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

