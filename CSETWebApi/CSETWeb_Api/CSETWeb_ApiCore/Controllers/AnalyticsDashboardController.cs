//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Analytics;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Dashboard;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class AnalyticsDashboardController : ControllerBase
    {
        private readonly ITokenManager _token;
        private IAnalyticsBusiness _analytics;

        public AnalyticsDashboardController(ITokenManager token, IAnalyticsBusiness analytics)
        {
            _token = token;
            _analytics = analytics;

        }

        [HttpGet]
        [Route("api/analyticsMaturityDashboard")]
        public List<AnalyticsMinMaxAvgMedianByGroup> getMaturityDashboardData([FromQuery] int maturity_model_id, int? sectorId, int? industryId)
        {
            int assessmentId = _token.AssessmentForUser();
            return _analytics.getMaturityDashboardData(maturity_model_id, sectorId, industryId);

        }
    }
}
