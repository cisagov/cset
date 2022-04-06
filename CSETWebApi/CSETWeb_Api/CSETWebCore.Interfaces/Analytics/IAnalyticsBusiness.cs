using CSETWebCore.DataLayer.Manual;
using System.Collections.Generic;

namespace CSETWebCore.Interfaces.Analytics
{
    public interface IAnalyticsBusiness
    {
        List<AnalyticsMinMaxAvgMedianByGroup> getMaturityDashboardData(int maturity_model_id);
    }
}