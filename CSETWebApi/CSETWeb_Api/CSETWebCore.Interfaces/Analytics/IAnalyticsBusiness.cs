using CSETWebCore.DataLayer.Manual;
using CSETWebCore.Model.Dashboard;
using System.Collections.Generic;

namespace CSETWebCore.Interfaces.Analytics
{
    public interface IAnalyticsBusiness
    {
        List<DataRowsAnalytics> getMaturityDashboardData(int maturity_model_id);
        List<AnalyticsgetMedianOverall> GetMaturityGroupsForAssessment(int assessmentId, int maturity_model_id);
    }
}