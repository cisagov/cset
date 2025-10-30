//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.Model.Dashboard;
using System.Collections.Generic;
using System.Threading.Tasks;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Analytics
{
    public interface IAnalyticsBusiness
    {
        Task<List<AnalyticsMinMaxAvgMedianByGroup>> getMaturityDashboardData(int maturity_model_id, int? sectorId, int? industryId);
        Task<List<AnalyticsgetMedianOverall>> GetMaturityGroupsForAssessment(int assessmentId, int maturity_model_id);
        Task<List<SetStandard>> GetStandardList(int assessmentId);
        Task<List<AnalyticsStandardMinMaxAvg>> GetStandardMinMaxAvg(int assessmentId, string setname, int? sectorId, int? industryId);
        Task<List<standardAnalyticsgetMedianOverall>> GetStandardSingleAvg(int assessmentId, string setname);
        public object GetAggregationAssessment(int assessmentId);
    }
}