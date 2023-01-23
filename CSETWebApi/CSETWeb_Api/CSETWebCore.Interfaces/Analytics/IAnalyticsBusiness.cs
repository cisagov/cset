//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.Model.Dashboard;
using System.Collections.Generic;

namespace CSETWebCore.Interfaces.Analytics
{
    public interface IAnalyticsBusiness
    {
        List<AnalyticsMinMaxAvgMedianByGroup> getMaturityDashboardData(int maturity_model_id,int? sectorId, int? industryId);
        List<AnalyticsgetMedianOverall> GetMaturityGroupsForAssessment(int assessmentId, int maturity_model_id);
        List<SetStandard> GetStandardList(int assessmentId);
        List<AnalyticsStandardMinMaxAvg> GetStandardMinMaxAvg(int assessmentId, string setname, int? sectorId, int? industryId);
        List<standardAnalyticsgetMedianOverall> GetStandardSingleAvg(int assessmentId, string setname);
    }
}